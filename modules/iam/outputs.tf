output "ecs_execution_role_arn" {
    description = "arn of the task execution role"
    value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
    description = "arn of the task role"
    value = aws_iam_role.ecs_task_role.arn
}