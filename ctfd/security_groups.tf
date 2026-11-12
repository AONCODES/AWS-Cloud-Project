# Security groups and their rules are managed separately to avoid circular dependencies between application tiers. Got an error before the fixes.

# Presentation Tier - Application Load Balancer

resource "aws_security_group" "alb" {
  name        = "ctfd_alb_sg"
  description = "Security group for CTFd Application Load Balancer"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ctfd_alb_sg"
  }
}

# Application Tier - EC2 instances

resource "aws_security_group" "ec2" {
  name        = "ctfd_ec2_sg"
  description = "Security group for CTFd application servers"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ctfd_ec2_sg"
  }
}

# DB Tier - RDS MySQL

resource "aws_security_group" "rds" {
  name        = "ctfd_rds_sg"
  description = "Security group for CTFd MySQL database"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ctfd_rds_sg"
  }
}

# DB Tier - Redis

resource "aws_security_group" "redis" {
  name        = "ctfd_redis_sg"
  description = "Security group for CTFd Redis cache"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ctfd_redis_sg"
  }
}



# ALB Rules
# Allow HTTP traffic from the internet to the ALB.

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

# Allow the ALB to forward requests to CTFd application servers.

resource "aws_vpc_security_group_egress_rule" "alb_to_ec2" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.ec2.id
  description                  = "Allow CTFd traffic to EC2"

  from_port   = 8000
  to_port     = 8000
  ip_protocol = "tcp"
}


# EC2 Rules
# Allow application traffic only from the ALB.

resource "aws_vpc_security_group_ingress_rule" "ec2_from_alb" {
  security_group_id            = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.alb.id
  description                  = "Allow CTFd traffic from ALB"

  from_port   = 8000
  to_port     = 8000
  ip_protocol = "tcp"
}

# Allow HTTPS for Docker image downloads and AWS API access.

resource "aws_vpc_security_group_egress_rule" "ec2_https" {
  security_group_id = aws_security_group.ec2.id
  description       = "Allow outbound HTTPS"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"
}

# Allow application connections to the MySQL database.

resource "aws_vpc_security_group_egress_rule" "ec2_to_rds" {
  security_group_id            = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.rds.id
  description                  = "Allow MySQL traffic to RDS"

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
}

# Allow application connections to the Redis cache.

resource "aws_vpc_security_group_egress_rule" "ec2_to_redis" {
  security_group_id            = aws_security_group.ec2.id
  referenced_security_group_id = aws_security_group.redis.id
  description                  = "Allow Redis traffic"

  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}


# RDS Rules
# Allow MySQL connections only from CTFd application servers.

resource "aws_vpc_security_group_ingress_rule" "rds_from_ec2" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.ec2.id
  description                  = "Allow MySQL from EC2"

  from_port   = 3306
  to_port     = 3306
  ip_protocol = "tcp"
}


# Redis Rules
# Allow Redis connections only from CTFd application servers.

resource "aws_vpc_security_group_ingress_rule" "redis_from_ec2" {
  security_group_id            = aws_security_group.redis.id
  referenced_security_group_id = aws_security_group.ec2.id
  description                  = "Allow Redis from EC2"

  from_port   = 6379
  to_port     = 6379
  ip_protocol = "tcp"
}