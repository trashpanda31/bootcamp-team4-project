resource "aws_cloudwatch_metric_alarm" "team4_high_cpu" {
  alarm_name          = "CloudSprint-team4-HighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    InstanceId = var.instance_id
  }

  treat_missing_data = "missing"
}
