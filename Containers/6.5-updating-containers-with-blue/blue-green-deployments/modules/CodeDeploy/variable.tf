variable "sysname" {
    type = string
}

variable "codedeploy_iam_arn" {
    type = string
}

variable "cluster_name" {
    type = string
}

variable "service_name" {
    type = string
}

variable "alb_listener_arn" {
    type = string
}

variable "alb_tg_group_blue_name" {
    type = string
}

variable "alb_tg_group_green_name" {
    type = string
}