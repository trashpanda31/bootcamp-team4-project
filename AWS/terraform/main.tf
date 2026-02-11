resource "aws_launch_template" "wordpress_lt" {
  name_prefix   = "cloudsprint-wp-template"
  image_id      = "ami-027547022824dc6e0"
  instance_type = var.instance_type
  iam_instance_profile {
    name = "Bootcamp-Instance-Profile"
  }

  vpc_security_group_ids = [
    aws_security_group.bc_team4_web_sg.id
  ]

  user_data = base64encode(file("userdata_docker.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "CloudSprint-ASG-WordPress"
    }
  }
}

resource "aws_lb_target_group" "wordpress_tg" {
  name     = "cloudsprint-team4-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_security_group" "alb_sg" {
  name = "cloudsprint-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "wordpress_alb" {
  name               = "cloudsprint-team4-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  desired_capacity = 1
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.private_subnets

  target_group_arns = [
    aws_lb_target_group.wordpress_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "CloudSprint-ASG-Instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "team4-cpu-scaling"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
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

resource "aws_instance" "jenkins_agent_team4" {
  ami                 = "ami-027547022824dc6e0"
  instance_type        = var.instance_type
  iam_instance_profile = "Bootcamp-Instance-Profile"

  vpc_security_group_ids = [
    aws_security_group.bc_team4_agent_sg.id
  ]

  user_data                   = file("userdata_agent.sh")
  user_data_replace_on_change  = true

  tags = {
    Name = "CloudSprint-Jenkins-Agent-team4"
  }
}


