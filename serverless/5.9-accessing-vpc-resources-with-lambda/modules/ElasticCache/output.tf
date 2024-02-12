output "redis_host" {
  value = aws_elasticache_cluster.example_redis_cluster.cache_nodes[0].address
}

output "redis_sg_id" {
  value = aws_security_group.elasticache_sg.id
}