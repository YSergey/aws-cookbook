variable "azs" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "az" {
  type = string
}

variable "region" {
  default = "us-west-2"
}

variable "instance_profile_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "instance_subnet_id" {
  type = string
}

variable "sysname" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group_name" {
  type = string
}