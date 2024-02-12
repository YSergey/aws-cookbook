variable "sysname" {
    type = string
}

# variable "lb_target_arn" {
#     type = string
# }

# variable "task_role_arn" {
#     type = string
# }

# variable "execution_role_arn" {
#     type = string
# }

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

variable "instance_profile" {
    type = string
}

variable "blue_tg_group_arn" {
  type = string
}