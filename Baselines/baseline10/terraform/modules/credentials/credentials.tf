resource "aws_ssm_parameter" "username" {
  name        = "/baseline08/username"
  description = "Dummy username for Baseline08"
  type        = "String"
  value       = "dummyuser"

  tags = {
    Name = "baseline08-username"
    Task = "IAM"
  }
}

resource "aws_ssm_parameter" "password" {
  name        = "/baseline08/password"
  description = "Dummy password for Baseline08"
  type        = "SecureString"
  value       = var.dummy_password

  tags = {
    Name = "baseline08-password"
    Task = "IAM"
  }
}