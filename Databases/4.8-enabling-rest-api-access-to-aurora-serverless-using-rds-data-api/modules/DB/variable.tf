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

variable "engine_mode" {
  type = string
}

variable "auto_pause" {
  type = bool
}

variable "min_capacity" {
  type = number
}

variable "max_capacity" {
  type = number
}

variable "seconds_until_auto_pause" {
  type = number
}