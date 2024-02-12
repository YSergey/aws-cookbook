# Use AWS Secrets Manager to generate a complex password
resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.sysname}-db-password"
  #検証用のため、パスワードの復旧は0日と定義している
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
  description = "Allow inbound traffic for Aurora MySQL"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_all" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
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
  availability_zones =  var.availability_zones
  skip_final_snapshot     = true

  iam_database_authentication_enabled = true

  vpc_security_group_ids  = [aws_security_group.db_sg.id]

}

# RDS Proxy 
resource "aws_db_proxy" "rds_proxy" {
  name                   = "db-proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = var.iam_rds_proxy_role
  vpc_security_group_ids = [ aws_security_group.db_sg.id ] # update with your RDS instance's security group
  vpc_subnet_ids         = [var.subnet_a_id, var.subnet_b_id] # update with your subnet IDs

  auth {
    auth_scheme = "SECRETS"
    iam_auth   = "REQUIRED"
    # Update with your secret ARN from Secrets Manager
    secret_arn  = aws_secretsmanager_secret.db_secret.arn
  }
}