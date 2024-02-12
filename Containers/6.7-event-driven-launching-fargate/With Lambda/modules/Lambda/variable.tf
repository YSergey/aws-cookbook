variable "lambda_execution_role_arn" {
  type = string
}

variable "file_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_arn" {
    type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_task_definition_arn" {
    type = string
}

variable "container_name" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "event_rule_arn" {
    type = string
}