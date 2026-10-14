data "aws_ami" "ubuntu" {
  most_recent = true

  # Canonical
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "tls_private_key" "vm_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "vm_key" {
  key_name   = var.vm_keypair
  public_key = tls_private_key.vm_key.public_key_openssh

  tags = {
    Name = var.vm_keypair
    Task = "VM"

  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.vm_key.private_key_pem
  filename        = "${path.root}/${var.vm_keypair}.pem"
  file_permission = "0400"
}


resource "aws_security_group" "vm" {
  name        = "vm-sg"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "vm-sg"
    Task = "VM"
  }
}

resource "aws_instance" "vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.vm_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.vm_key.key_name
  iam_instance_profile        = "LabInstanceProfile"

  user_data = file("${path.root}/cloudinit/sample.yaml")

  tags = {
    Name = "vm"
    Task = "VM"
  }
}
resource "aws_ami_from_instance" "custom_ami" {
  name = "nginx-ami"
  source_instance_id = aws_instance.vm.id

  tags = {
    Name = "nginx-ami"
    Task = "Custom VM image"
  }
}

resource "aws_instance" "image_vm" {
  ami                         = aws_ami_from_instance.custom_ami.id
  instance_type               = var.vm_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.vm_key.key_name
  iam_instance_profile        = "LabInstanceProfile"

  tags = {
    Name = "image-vm"
    Task = "Custom VM image"
  }
}

resource "aws_instance" "private_vm" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.vm_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.vm_key.key_name
  iam_instance_profile        = "LabInstanceProfile"

  user_data = file("${path.root}/cloudinit/sample.yaml")

  tags = {
    Name = "private-vm"
    Task = "NAT Gateway"
  }
}