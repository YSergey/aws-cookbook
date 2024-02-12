variable "source_db_name" {
    type = string
}

variable "target_db_name" {
    type = string
}

variable "source_server_name" {
    type = string
}

variable "target_server_name" {
    type = string
}

variable "source_db_username" {
    type = string
}

variable "target_db_username" {
    type = string
}

variable "source_db_password" {
  description = "Password for the source DB"
  type = string
}

variable "target_db_password" {
  description = "Password for the target DB"
  type = string
}

variable "source_db_endpoint_identifer" {
    type = string
}

variable "target_db_endpoint_identifer" {
    type = string
}

variable "instance_class" {
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

variable "file_path" {
    type = string
}