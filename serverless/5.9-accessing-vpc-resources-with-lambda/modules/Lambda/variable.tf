variable "sysname" {
  type = string
}

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

variable vpc_id {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "redis_host" {
  type = string
}

variable "subnet_a_cidr" {
  type = string
}

variable "subnet_b_cidr" {
  type = string
}

variable "redis_sg_id" {
  type = string
}