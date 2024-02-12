variable "sysname" {
    type = string
}

variable "target_bucket_name" {
    type = string
}

variable "ecs_cluster_arn" {
    type = string
}

variable "ecs_task_definition_arn" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "ecs_sg_id" {
    type = string
}

variable "container_name" {
    type = string
}