variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs for Lambda"
  type        = list(string)
}

variable "allow_lb_permission" {
  description = "to attach ALB to lambda"
}