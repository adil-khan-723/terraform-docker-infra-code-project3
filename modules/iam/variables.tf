variable "environment" {
  type = string
}

variable "task_role_policy_arns" {
  type    = list(string)
  default = []
}

variable "ecr_repository_arn" {
  type = string
}