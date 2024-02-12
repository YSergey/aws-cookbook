variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "lambda_vtg" {
  type = string
}

variable "lambda_function_name" {
  type = string
}

variable "alb_sg" {
  type = string
}

variable "fargate_arn"{
  type = string
}
