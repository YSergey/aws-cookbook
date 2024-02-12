
variable "lambda_execution_role_arn" {
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

variable "signed_code_bucket" {
  type = string
}

variable "path_key" {
  type = string
}

variable "object_key" {
  type = string
}

variable "lambda_code_signing_config_arn" {
  type = string
}