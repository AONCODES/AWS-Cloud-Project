resource "aws_lambda_function" "slack_notifier" {
  function_name = "slack-notifier"
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  timeout = 15

  environment {
    variables = {
      SLACK_WEBHOOK_PARAMETER = var.slack_webhook_parameter
    }
  }

  tags = {
    Name = "slack-notifier"
    Task = "Serverless to Slack Integration"
  }
}