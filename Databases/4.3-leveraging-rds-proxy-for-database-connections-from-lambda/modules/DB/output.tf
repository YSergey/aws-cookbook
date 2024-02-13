output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}

output "db_proxy_sg_id" {
  value = aws_security_group.db_proxy_sg.id
}

output "rds_proxy_endpoint"{
  value = aws_db_proxy.rds_proxy.endpoint
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}