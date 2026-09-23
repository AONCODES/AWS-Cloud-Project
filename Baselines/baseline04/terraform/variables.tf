variable "aws_region" {}
variable "vpc_cidr" {}
variable "subnet_web_cidr" {}

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