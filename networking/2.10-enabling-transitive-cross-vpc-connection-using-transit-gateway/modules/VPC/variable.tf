variable sysname {}
variable cidr_block {}

variable public_subnet_1_cidr{}
variable public_subnet_2_cidr {}
variable isolated_subnet_1_cidr{}
variable isolated_subnet_2_cidr{}
variable availability_zone_1 {}
variable availability_zone_2 {}

variable "create_igw" {
  description = "Whether to create an IGW"
  type        = bool
}

variable "route_transit_gateway" {
  type = bool
}

variable "transit_gateway_id" {
  type = string
}