variable "sysname" {
    type = string
}

variable "vpc1_id" {
    type = string
}

variable "vpc1_cidr" {
    type = string
}

variable "vpc2_id" {
    type = string
}

variable "vpc2_cidr" {
    type = string
}

variable "vpc3_id" {
    type = string
}

variable "vpc3_cidr" {
    type = string
}

variable "subnet1_ids" {
    type = list(string)
}

variable "subnet2_ids" {
    type = list(string)
}

variable "subnet3_ids" {
    type = list(string)
}

variable "vpc1_public_rt" {
    description = "public route table"
    type = string
}

variable "vpc1_isolated_rt" {
    description = "isolated route table"
    type = string
}

variable "vpc2_rt" {
    description = "isolated route table"
    type = string
}

variable "vpc3_rt" {
    description = "isolated route table"
    type = string
}