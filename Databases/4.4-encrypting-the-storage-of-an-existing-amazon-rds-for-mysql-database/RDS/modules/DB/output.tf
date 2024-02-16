output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}

output "rds_instance_id" {
  value = aws_rds_cluster_instance.rds_instance.id
}

output "db_subnet_group_name" {
  value = aws_rds_cluster.aurora_cluster.db_subnet_group_name
}