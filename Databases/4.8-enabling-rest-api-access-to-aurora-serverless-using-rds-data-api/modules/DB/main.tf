# Use AWS Secrets Manager to generate a complex password
resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.sysname}-db-password"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = "{\"password\":\"${random_password.password.result}\"}"
}

resource "random_password" "password" {
  length  = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create a database subnet group
resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "aurora_db_subnet_group"
  subnet_ids = [var.subnet_a_id, var.subnet_b_id]

  tags = {
    Name = "${var.sysname}-aurora_db_subnet_group"
  }
}

# Create VPC security group for the database
resource "aws_security_group" "db_sg" {
  name        = "${var.sysname}-aurora_db_sg"
  description = "Allow inbound traffic for Aurora PostgreSQL"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_all" {
  type        = "ingress"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_sg.id
}

# Create Aurora Serverless cluster
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = var.cluster_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = random_password.password.result
  db_subnet_group_name    = aws_db_subnet_group.aurora_db_subnet_group.name
  skip_final_snapshot     = true
  engine_mode             = var.engine_mode
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  enable_http_endpoint = true

  scaling_configuration {
    auto_pause               = var.auto_pause
    min_capacity             = var.min_capacity
    max_capacity             = var.max_capacity
    seconds_until_auto_pause = var.seconds_until_auto_pause
  }

}
