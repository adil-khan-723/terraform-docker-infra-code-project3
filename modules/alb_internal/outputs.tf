output "internal_alb_arn" {
  description = "arn of the internal alb"
  value       = aws_lb.internal.arn
}

output "internal_alb_dns_name" {
  description = "dns name of the internal alb"
  value       = aws_lb.internal.dns_name
}

output "backend_target_grouo_arn" {
  description = "arn of the backend target group"
  value       = aws_lb_target_group.backend.arn
}