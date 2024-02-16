variable "sysname" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_a_id" {
  type = string
}

variable "subnet_b_id" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "cluster_identifier" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "database_name" {
  type = string
}

variable "master_username" {
  type = string 
}

variable "instance_class" {
  type = string
}