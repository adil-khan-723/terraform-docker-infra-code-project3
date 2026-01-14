output "public_alb_arn" {
  description = "arn ofn the public alb"
  value       = aws_lb.public.arn
}

output "public_alb_dns_name" {
  description = "dns name of the public alb"
  value       = aws_lb.public.dns_name
}

output "frontend_target_group_arn" {
  description = "arn of the public target group"
  value       = aws_lb_target_group.frontend.arn
}