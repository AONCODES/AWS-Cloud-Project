variable "aws_region" {}
variable "vpc_cidr" {}
variable "subnet_public_az1_cidr" {}
variable "subnet_public_az2_cidr" {}
variable "subnet_private_az1_cidr" {}
variable "subnet_private_az2_cidr" {}


variable "vm_type" {}
variable "vm_keypair" {}

variable "dummy_password" {
  description = "Dummy password for Parameter Store"
  type        = string
  sensitive   = true
}