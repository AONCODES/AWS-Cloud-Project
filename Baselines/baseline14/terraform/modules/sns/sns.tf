resource "aws_sns_topic" "budget_alerts" {
  name = "budget-alerts"

  tags = {
    Name = "budget-alerts"
    Task = "Setup Budget and Slack Notification"
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "budget_publish" {
  statement {
    sid    = "AllowAWSBudgetsToPublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }

    actions = [
      "SNS:Publish"
    ]

    resources = [
      aws_sns_topic.budget_alerts.arn
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "budget_alerts" {
  arn    = aws_sns_topic.budget_alerts.arn
  policy = data.aws_iam_policy_document.budget_publish.json
}