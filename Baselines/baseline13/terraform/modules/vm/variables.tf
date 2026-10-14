variable "aws_region" {
  default = "eu-north-1"
}

variable "vpc_id" {}

variable "subnet_id" {}

variable "vm_type" {
  default = "t3.micro"
}

variable "vm_keypair" {}

variable "private_subnet_id" {
  description = "Private subnet ID for the private VM"
  type        = string
}
