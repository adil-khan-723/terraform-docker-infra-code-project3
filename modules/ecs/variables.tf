variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "container_definitions" {
  type = any
}