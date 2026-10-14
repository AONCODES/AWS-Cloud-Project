variable "budget_amount" {
  description = "Monthly AWS cost budget in USD"
  type        = string
  default     = "5"
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic receiving budget alerts"
  type        = string
}