resource "aws_lb" "team4_alb" {
  name               = "CloudSprint-team4-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.public_subnet_ids

  tags = merge(var.tags, { Name = "CloudSprint-team4-alb" })
}

resource "aws_lb_target_group" "team4_tg" {
  name        = "CloudSprint-team4-tg"
  port        = var.app_container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.team4.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = var.healthcheck_path
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
  }

  tags = merge(var.tags, { Name = "CloudSprint-team4-tg" })
}

resource "aws_lb_listener" "team4_http" {
  load_balancer_arn = aws_lb.team4_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.team4_tg.arn
  }
}
