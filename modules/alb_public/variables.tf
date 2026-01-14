variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "public_alb_public_subnet_ids" {
  description = "load balancer subnets"
  type        = list(string)
}

variable "public_alb_sg_id" {
  description = "security group id for the public alb"
  type        = string
}

variable "public_alb_frontend_port" {
  description = "frontend port on which containers run"
  type        = number
  default     = 80
}