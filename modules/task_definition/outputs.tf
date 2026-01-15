output "task_definition_arn" {
    description = "arn of the task definition"
    value = aws_ecs_task_definition.this.arn
}

output "task_definition_family" {
    description = "name of the task definition"
    value = aws_ecs_task_definition.this.family
}