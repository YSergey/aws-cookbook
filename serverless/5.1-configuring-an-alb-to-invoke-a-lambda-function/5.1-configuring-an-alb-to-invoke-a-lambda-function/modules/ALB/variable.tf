variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "lambda_tg_arn" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "load_balancer_type" {
    type = string
}