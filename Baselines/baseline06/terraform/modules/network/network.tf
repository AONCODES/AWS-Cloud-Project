resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "workshop-vpc"
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
  }
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_az2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-az2"
  }
}

resource "aws_subnet" "private_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_private_az1_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-az1"
  }
}

resource "aws_subnet" "private_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_private_az2_cidr
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-az2"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "workshop-igw"
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "web-rt"
  }
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.web.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.web.id
}

# public Firewalls 

resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-nacl"
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