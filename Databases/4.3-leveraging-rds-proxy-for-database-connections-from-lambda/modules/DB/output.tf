output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}

output "rds_proxy_endpoint"{
  value = aws_db_proxy.rds_proxy.endpoint
}