resource "aws_instance" "cloudsprint_team4" {
  ami                  = "ami-027547022824dc6e0"
  instance_type         = var.instance_type
  iam_instance_profile  = "Bootcamp-Instance-Profile"

  vpc_security_group_ids = [
    aws_security_group.bc_team4_web_sg.id
  ]

  user_data = file("userdata_docker.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "CloudSprint-team4"
  }
}

resource "aws_instance" "jenkins_team4" {
  ami                  = "ami-027547022824dc6e0"
  instance_type         = var.instance_type
  iam_instance_profile  = "Bootcamp-Instance-Profile"

  vpc_security_group_ids = [
    aws_security_group.bc_team4_jenkins_sg.id
  ]

  user_data = file("userdata_jenkins.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "CloudSprint-Jenkins-team4"
  }
}

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
