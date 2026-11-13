# Subnet group for the CTFd MySQL database.

resource "aws_db_subnet_group" "ctfd" {
  name = "ctfd_db_subnet_group"

  subnet_ids = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]

  tags = {
    Name = "ctfd_db_subnet_group"
  }
}

# RDS MySQL database for CTFd.

resource "aws_db_instance" "ctfd" {
  identifier = "ctfd-mysql"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_encrypted = true

  db_name                     = "ctfd"
  username                    = "admin"
  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.ctfd.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = false
  publicly_accessible = false

  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Name = "ctfd_mysql"
  }
}

# Subnet group for the CTFd Redis cache.
resource "aws_elasticache_subnet_group" "ctfd" {
  name = "ctfd_redis_subnet_group"

  subnet_ids = [
    aws_subnet.private_db_a.id,
    aws_subnet.private_db_b.id
  ]

  tags = {
    Name = "ctfd_redis_subnet_group"
  }
}

