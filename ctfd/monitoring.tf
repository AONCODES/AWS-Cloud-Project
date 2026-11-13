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

  dimensions = {
    TargetGroup  = aws_lb_target_group.ctfd.arn_suffix
    LoadBalancer = aws_lb.ctfd.arn_suffix
  }
}