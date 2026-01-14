resource "aws_lb" "public" {
  name               = "alb-public-${var.environment}"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.public_alb_sg_id]
  subnets            = var.public_alb_public_subnet_ids

  tags = {
    Name        = "public-alb-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "frontend" {
  name        = "frontend-tg-${var.environment}"
  port        = var.public_alb_frontend_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "frontend-tg-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}