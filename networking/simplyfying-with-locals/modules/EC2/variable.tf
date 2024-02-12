variable "region" {
  default = "us-west-2"
}

variable "availability_zone" {
  type = string
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