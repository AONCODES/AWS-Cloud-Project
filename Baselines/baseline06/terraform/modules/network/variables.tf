variable "aws_region" {
  default = "eu-north-1" 
}

variable "vpc_cidr" {
  default = "10.0.0.0/24"
}

variable "subnet_public_az1_cidr" {
  default = "10.0.0.0/28"
}

variable "subnet_public_az2_cidr" {
  default = "10.0.0.16/28"
}

variable "subnet_private_az1_cidr" {
  default = "10.0.0.32/28"
}

variable "subnet_private_az2_cidr" {
  default = "10.0.0.48/28"
}