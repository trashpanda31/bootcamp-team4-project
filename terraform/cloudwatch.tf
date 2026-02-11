resource "aws_cloudwatch_metric_alarm" "team4_asg_high_cpu" {
  alarm_name          = "CloudSprint-team4-ASG-HighCPU"
  alarm_description   = "Average CPU across ASG is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  treat_missing_data  = "missing"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.team4_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "team4_asg_status_failed" {
  alarm_name          = "CloudSprint-team4-ASG-StatusCheckFailed"
  alarm_description   = "One or more instances in ASG failing status checks"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "notBreaching"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.team4_asg.name
  }
}
