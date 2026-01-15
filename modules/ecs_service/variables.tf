variable "service_name" {
    description = "name of the service"
    type = string
}

variable "environment" {
    description = "Envronment name (dev/prod)"
    type = string
}

variable "cluster_arn" {
    description = "arn of the cluster to run the td in"
    type = string
}

variable "task_definition_arn" {
    description = "arn of the task definition"
    type = string
}

variable "desired_count" {
    description = "number of containers to run"
    type = number
}

variable "launch_type" {
    description = "type of compute to launch the service in"
    type = string
    default = "FARGATE"
}

variable "subnet_ids" {
    description = "id of the subnet"
    type = list(string)
}

variable "security_group_ids" {
    description = "id of the security group"
    type = list(string)
}

variable "target_group_arn" {
    description = "arn of the target group"
    type = string
}

variable "container_name" {
    description = "name of the container"
    type = string
}

variable "container_port" {
    description = "port of the container"
    type = number
}