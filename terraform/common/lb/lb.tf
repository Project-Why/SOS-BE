resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  tags = {
    Name = "app-lb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name                 = "app-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.ecs_vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app-tg"
  }
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

output "app_tg_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "app_lb_listener_arn" {
  value = aws_lb_listener.app_lb_listener.arn
}