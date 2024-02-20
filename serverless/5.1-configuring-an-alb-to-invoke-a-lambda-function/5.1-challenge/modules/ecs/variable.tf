variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "alb_security_group" {
  description = "Security group for the ALB"
  type        = string
}

variable "ecs_security_group" {
  description = "Security group for ECS"
  type        = string
}
