
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

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "efs_accesspoint_arn" {
  type = string
}

variable "efs_sd_id" {
  type = string
}