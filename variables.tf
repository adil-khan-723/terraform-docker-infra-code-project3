variable "aws_region" {
  type        = string
  description = "aws region"
}

variable "environment" {
  type        = string
  description = "type of environment (dev/prod)"
}

variable "backend_image_tag" {
  type        = string
  description = "Docker image tag for backend (from CI)"
}

variable "frontend_image_tag" {
  type        = string
  description = "Docker image tag for frontend (from CI)"
}