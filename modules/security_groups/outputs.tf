output "public_alb_sg_id" {
  description = "public alb sg id"
  value       = aws_security_group.public_alb_sg.id
}

output "frontend_sg_id" {
  description = "frontend containers sg id"
  value       = aws_security_group.frontend_sg.id
}

output "internal_alb_sg_id" {
  description = "internal alb sg id"
  value       = aws_security_group.internal_alb_sg.id
}

output "backend_sg_id" {
  description = "backend containers sg id"
  value       = aws_security_group.backend_sg.id
}