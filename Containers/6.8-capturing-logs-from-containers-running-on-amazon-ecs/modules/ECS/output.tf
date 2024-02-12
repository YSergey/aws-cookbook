output "ecs_sg_id" {
    value = aws_security_group.ecs_sg.id
}

output "cluster_name" {
    value = aws_ecs_cluster.ecs_cluster.name
}

output "cluster_arn" {
    value = aws_ecs_cluster.ecs_cluster.arn
}

output "service_name" {
    value = aws_ecs_service.ecs_service.name
}

output "ecs_task_definition_arn" {
    value = aws_ecs_task_definition.example.arn
}
