variable "sysname" {
    type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_public_cidr" {
    type = string
}

variable "subnet_ec2_a_cidr" {
    type = string
}

variable "subnet_ec2_b_cidr" {
    type = string
}

variable "subnet_db_a_cidr" {
    type = string
}

variable "subnet_db_b_cidr" {
    type = string
}

variable "az_a" {
  type = string
}

variable "az_b" {
  type = string
}