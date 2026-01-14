variable "environment" {
  description = "environment name (dev/prod)"
  type        = string
}

variable "vpc_cidr" {
  type        = string
  description = "cidr range for the vpc"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "availability zones"
  type        = list(string)
}