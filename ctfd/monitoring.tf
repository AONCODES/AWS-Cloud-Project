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
