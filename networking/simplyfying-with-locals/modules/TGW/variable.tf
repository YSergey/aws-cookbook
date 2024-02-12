variable "azs" {
    default = ["us-west-2a", "us-west-2b"]
}

variable "vpc1_id" {
    type = string
}

variable "vpc2_id" {
    type = string
}

variable "vpc3_id" {
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

variable "isolated_route_table_1_id" {
    type = string
}

variable "isolated_route_table_2_id" {
    type = string
}

variable "isolated_route_table_3_id" {
    type = string
}

variable "public_route_table_1_id" {
    type = string
}

variable "public_route_table_2_id" {
    type = string
}

variable "public_route_table_3_id" {
    type = string
}

variable "vpc1_private_subnets" {
    type = string
}

variable "vpc2_private_subnets" {
    type = string
}

variable "vpc3_private_subnets" {
    type = string
}

variable "vpc1_public_subnets" {
    type = string
}

variable "vpc2_public_subnets" {
    type = string
}

variable "vpc3_public_subnets" {
    type = string
}

variable "nat_gateway_id" {
    type = string
}