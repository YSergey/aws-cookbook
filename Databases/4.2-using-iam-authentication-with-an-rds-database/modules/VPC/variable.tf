variable "sysname" {
    type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnets_variable" {
  type = list(object({
    cidr = string
    az   = string
    map_public_ip_on_launch = bool
    subnet_name = string
  }))
}

variable "route_table_variable" {
  type = list(object({
    table_name = string
  }))
}