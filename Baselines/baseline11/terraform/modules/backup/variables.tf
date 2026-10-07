variable "vm_arn" {
  description = "ARN of the VM to back up"
  type        = string
}

variable "backup_role_arn" {
  description = "IAM role ARN used by AWS Backup"
  type        = string
}