output "ecs_execution_role_arn" {
    description = "arn of the task execution role"
    value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
    description = "arn of the task role"
    value = aws_iam_role.ecs_task_role.arn
}

output "ci_ecr_push_role_arn" {
    description = "CI ECR push role ARN"
    value = aws_iam_role.ci_ecr_push_role.arn
}

output "jenkins_instance_profile_name" {
    description = "jenkins instance profile arn"
    value = aws_iam_instance_profile.jenkins.name
}