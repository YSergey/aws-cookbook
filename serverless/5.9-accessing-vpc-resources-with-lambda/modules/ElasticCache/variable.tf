variable "sysname" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "lambda_sg_id" {
    type = string
}