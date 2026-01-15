variable "environment" {
    description = "Environment name (dev/prod)"
    type = string
}

variable "task_role_policy_arns" {
    description = "arns of the policies to be attached to the task role"
    type = list(string)
    default = []
}

variable "ci_principal_arn" {
  description = "arn of the principal"
  type = string
}

variable "ecr_repository_arn" {
  description = "arn of the ecr repo"
  type = string
}