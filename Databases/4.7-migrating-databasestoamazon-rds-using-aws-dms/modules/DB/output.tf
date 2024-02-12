output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}

output "rds_instance_id"{
  value = aws_rds_cluster_instance.rds_source_instance.id
}

output "source_db_name" {
  value = aws_rds_cluster_instance.rds_source_instance.cluster_identifier
}

output "target_db_name" {
  value = aws_rds_cluster_instance.rds_target_instance.cluster_identifier
}

output "source_db_endpoint_id" {
  value = aws_rds_cluster_instance.rds_source_instance.endpoint
}