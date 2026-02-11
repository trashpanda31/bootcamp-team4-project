resource "aws_autoscaling_group" "team4_asg" {
  name                = "CloudSprint-team4-asg"
  min_size            = var.asg_min
  desired_capacity    = var.asg_desired
  max_size            = var.asg_max
  vpc_zone_identifier = local.private_subnet_ids

  health_check_type         = "ELB"
  health_check_grace_period = var.instance_warmup

  target_group_arns = [aws_lb_target_group.team4_tg.arn]

  launch_template {
    id      = aws_launch_template.team4_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = var.min_healthy_percentage
      instance_warmup        = var.instance_warmup
    }
  }

  tag {
    key                 = "Name"
    value               = "CloudSprint-team4"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
