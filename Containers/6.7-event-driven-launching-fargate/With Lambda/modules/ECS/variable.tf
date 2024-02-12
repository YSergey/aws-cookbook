variable "sysname" {
    type = string
}

variable "ecr_repository_url" {
    type = string
}

variable "container_name" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "alb_sg_id" {
    type = string
}

variable "ecs_iam_role" {
    type = string
}

variable "blue_tg_group_arn" {
  type = string
}