# Monitor healthy CTFd instances behind the ALB.
resource "aws_cloudwatch_metric_alarm" "ctfd_unhealthy" {
  alarm_name          = "ctfd-no-healthy-targets"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Minimum"
  threshold           = 2

  alarm_actions = [aws_sns_topic.ctfd_alerts.arn]

  dimensions = {
    TargetGroup  = aws_lb_target_group.ctfd.arn_suffix
    LoadBalancer = aws_lb.ctfd.arn_suffix
  }
}

# SNS topic for monitoring notifications.
resource "aws_sns_topic" "ctfd_alerts" {
  name = "ctfd-alerts"
}

# Monitor monthly AWS costs.
resource "aws_budgets_budget" "ctfd" {
  name         = "ctfd-monthly-budget"
  budget_type  = "COST"
  limit_amount = "10"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                 = 80
    threshold_type            = "PERCENTAGE"
    notification_type         = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.ctfd_alerts.arn]
  }

    depends_on = [aws_sns_topic_policy.ctfd_alerts]
}

# Allow AWS Budgets to publish SNS notifications.
data "aws_caller_identity" "current" {}

resource "aws_sns_topic_policy" "ctfd_alerts" {
  arn = aws_sns_topic.ctfd_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
        Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "budgets.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.ctfd_alerts.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.ctfd_alerts.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# Package the Slack notification Lambda.
data "archive_file" "slack_lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Send SNS notifications to Slack.
resource "aws_lambda_function" "slack_notifier" {
  function_name = "ctfd-slack-notifier"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.slack_lambda.output_path
  source_code_hash = data.archive_file.slack_lambda.output_base64sha256

  timeout = 15

  environment {
    variables = {
      SLACK_WEBHOOK_PARAMETER = "/baseline13/slack/webhook"
    }
  }
}

# Subscribe the Lambda function to SNS alerts.
resource "aws_sns_topic_subscription" "slack" {
  topic_arn = aws_sns_topic.ctfd_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.slack_notifier.arn
}

# Allow SNS to invoke the Lambda function.
resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_notifier.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.ctfd_alerts.arn
}