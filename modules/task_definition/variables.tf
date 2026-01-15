variable "project_name" {
    description = "name of the project"
    type = string
}

variable "environment" {
    description = "Environment name (dev/prod)"
    type = string
}

variable "cpu" {
    description = "cpu count for container"
    type = number
}

variable "memory" {
    description = "memory for the container"
    type = number
}

variable "task_execution_role_arn" {
    description = "arn for the task execution role"
    type = string
}

variable "task_definition_role_arn" {
    description = "arn for the task execution role"
    type = string
}

variable "container_definitions" {
    description = "container definiton"
    type = any
}