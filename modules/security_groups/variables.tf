variable "environment" {
  type        = string
  description = "Environment name (dev/prod)"
}

variable "vpc_id" {
  type        = string
  description = "id of the vpc"
}

variable "frontend_port" {
  type        = number
  description = "port at which frontend containers listen"
  default     = 80
}

variable "backend_port" {
  type        = number
  description = "port at which backend containers listen"
  default     = 5001
}