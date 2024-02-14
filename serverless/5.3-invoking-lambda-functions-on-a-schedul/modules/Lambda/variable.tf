variable "sysname" {
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

variable "vpc_cidr" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "DB_HOST" {
    type = string
}

variable "USER_NAME" {
    type = string
}

variable "db_proxy_sg_id" {
  type = string
}