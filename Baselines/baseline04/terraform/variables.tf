variable "aws_region" {}
variable "vpc_cidr" {}
variable "subnet_public_az1_cidr" {}
variable "subnet_public_az2_cidr" {}
variable "subnet_private_az1_cidr" {}
variable "subnet_private_az2_cidr" {}

variable "vm_type" {}
variable "vm_keypair" {}

variable "Owner" {
  type    = string
  default = "learner"
}

variable "Environment" {
  type    = string
  default = "workshop"
}