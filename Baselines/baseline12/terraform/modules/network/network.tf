resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "workshop-vpc"
    Task = "Networking"
  }
}

# subnets 

resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_az1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-az1"
    Task = "Networking"
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_az2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-az2"
    Task = "Networking"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_private_az1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-az1"
    Task = "Networking"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_private_az2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-az2"
    Task = "Networking"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "workshop-igw"
    Task = "Networking"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
    Task = "NAT Gateway"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_az1.id

  tags = {
    Name = "nat-gateway"
    Task = "NAT Gateway"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-rt"
    Task = "NAT Gateway"
  }
}

resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
    Task = "Networking"
  }
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# public Firewalls 

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-nacl"
    Task = "Firewall"
  }
}

resource "aws_network_acl_rule" "public_ingress_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_ingress_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}



resource "aws_network_acl_rule" "public_ingress_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_ingress_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 130
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "egress_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 200
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  network_acl_id = aws_network_acl.public.id
}

resource "aws_network_acl_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  network_acl_id = aws_network_acl.public.id
}

# priva firewalls

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-nacl"
    Task = "Firewall"
  }
}
resource "aws_network_acl_rule" "private_ingress_ssh_public_az1" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.subnet_public_az1_cidr
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "private_ingress_http_public_az1" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.subnet_public_az1_cidr
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "private_ingress_https_public_az1" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.subnet_public_az1_cidr
  from_port      = 443
  to_port        = 443
}
resource "aws_network_acl_rule" "private_ingress_ssh_public_az2" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 200
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.subnet_public_az2_cidr
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "private_ingress_http_public_az2" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 210
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.subnet_public_az2_cidr
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "private_ingress_https_public_az2" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 220
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.subnet_public_az2_cidr
  from_port      = 443
  to_port        = 443
}
resource "aws_network_acl_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  network_acl_id = aws_network_acl.private.id
}

resource "aws_network_acl_association" "private_az2" {
  subnet_id      = aws_subnet.private_az2.id
  network_acl_id = aws_network_acl.private.id
}