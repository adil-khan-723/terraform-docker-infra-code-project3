resource "aws_lb" "internal" {
  name               = "alb-internal-${var.environment}"
  load_balancer_type = "application"
  internal           = true
  security_groups    = [var.internal_alb_sg_id]
  subnets            = var.internal_alb_private_subnet_ids

  tags = {
    Name        = "internal-alb-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "backend" {
  name        = "backend-tg-${var.environment}"
  port        = var.internal_alb_backend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "backend-tg-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}