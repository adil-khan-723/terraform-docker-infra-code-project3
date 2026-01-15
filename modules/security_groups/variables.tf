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

variable "ssh_port" {
  description = "ssh port"
  type = number
  default = 22
}

variable "jenkins_port" {
  description = "jenkins port"
  default = 8080
  type = number
}