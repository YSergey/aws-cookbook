output "ecs_iam_role_arn" {
    value = aws_iam_role.ecs_execution_role.arn
}

output "instance_profile" {
    value = aws_iam_instance_profile.ecs_instance_profile.name
}