variable "internal_alb_sg_id" {
  description = "security group id for the internal alb"
  type        = string
}

variable "internal_alb_private_subnet_ids" {
  description = "load balancer subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "internal_alb_backend_port" {
  description = "backend port on which containers run"
  type        = number
  default     = 5001
}
