resource "aws_elasticache_subnet_group" "example_subnet_group" {
  name       = "${var.sysname}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "example_redis_cluster" {
  cluster_id           = "${var.sysname}-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.example_subnet_group.name
  security_group_ids   = [aws_security_group.elasticache_sg.id]
}

# Elasticache Security Group
resource "aws_security_group" "elasticache_sg" {
  name        = "${var.sysname}-elasticache-sg"
  description = "Security group for ElastiCache Redis Cluster"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "elasticache_inbound_from_lambda" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = aws_security_group.elasticache_sg.id
  source_security_group_id = var.lambda_sg_id
}

