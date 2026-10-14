variable "lambda_role_arn" {
  description = "IAM role ARN used by the Lambda function"
  type        = string
}

variable "slack_webhook_parameter" {
  description = "SSM parameter name containing the Slack webhook URL"
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the Lambda deployment package"
  type        = string
}