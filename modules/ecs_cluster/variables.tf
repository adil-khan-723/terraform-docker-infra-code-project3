variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "enable_container_insights" {
  description = "Enable cloudwatch container insights"
  type        = bool
  default     = false
}