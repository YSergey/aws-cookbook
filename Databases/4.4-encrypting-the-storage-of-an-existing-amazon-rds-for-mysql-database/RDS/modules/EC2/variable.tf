variable "sysname" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "create_endpoint" {
  type = bool
}

variable "route_table_id" {
  type = string
}

variable "iam_role_arn" {
  type = string
}

variable "db_security_group_id" {
  type = string
}