output "ecs_iam_role_arn" {
    value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
    value = aws_iam_role.ecs_task_role.arn
}

output "codedeploy_ima_arn" {
    value = aws_iam_role.codedeploy_role.arn
}