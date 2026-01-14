output "ecs_cluster_id" {
  description = "id of the ecs cluster"
  value       = aws_ecs_cluster.cluster.id
}

output "ecs_cluster_arn" {
  description = "arn of the ecs cluster"
  value       = aws_ecs_cluster.cluster.arn
}

output "ecs_cluster_name" {
  description = "name of the ecs cluster"
  value       = aws_ecs_cluster.cluster.name
}