# Use AWS Secrets Manager to generate a complex password
resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.sysname}-db-password"
  #検証用のため、パスワードの復旧は0日と定義している
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "${var.master_username}"
    password = "${random_password.password.result}"
  })
}

resource "random_password" "password" {
  length  = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Create a database subnet group
resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name       = "aurora-db-subnet-group"
  subnet_ids = [var.subnet_a_id, var.subnet_b_id]

  tags = {
    Name = "${var.sysname}-aurora-db-subnet-group"
  }
}

# Create VPC security group for the database
resource "aws_security_group" "db_sg" {
  name        = "${var.sysname}-aurora-db-sg"
  description = "Allow inbound traffic for Aurora MySQL"
  vpc_id      = var.vpc_id

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# Grant EC2 instance security group access to MySQL port
resource "aws_security_group_rule" "ec2_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = var.ec2_sg_id
  security_group_id        = aws_security_group.db_sg.id
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

  vpc_security_group_ids  = [ aws_security_group.db_sg.id ]

}

resource "aws_rds_cluster_instance" "rds_instance" {
  identifier         = "database-cluster-instance"
  cluster_identifier = aws_rds_cluster.aurora_cluster.id

  engine = aws_rds_cluster.aurora_cluster.engine
  engine_version = aws_rds_cluster.aurora_cluster.engine_version

  instance_class = var.instance_class
  db_subnet_group_name = aws_rds_cluster.aurora_cluster.db_subnet_group_name
}

#Create Encrypted DB Instance
resource "aws_kms_key" "db_encryption" {
  description = "Key for RDS DB Encryption"
  deletion_window_in_days = 7

  tags = {
    Name = "${var.sysname}-kms"
  }
}

resource "aws_kms_alias" "db_encryption_alias" {
  name          = "alias/my-db-encryption-key"
  target_key_id = aws_kms_key.db_encryption.key_id
}

resource "aws_rds_cluster" "restored_from_snapshot" {
  cluster_identifier          = "restored-cluster"
  master_username         = var.master_username
  master_password         = random_password.password.result
  engine = var.engine
  engine_version          = var.engine_version
  snapshot_identifier         = aws_rds_cluster.aurora_cluster.snapshot_identifier
  storage_encrypted = true
  skip_final_snapshot     = true

  kms_key_id                  = aws_kms_key.db_encryption.arn
  db_subnet_group_name        = aws_db_subnet_group.aurora_db_subnet_group.name
  vpc_security_group_ids      = [ aws_security_group.db_sg.id ]

  depends_on = [ aws_rds_cluster_instance.rds_instance ]
}

resource "aws_rds_cluster_instance" "restored_instance" {
  identifier         = "restored-instance"
  cluster_identifier = aws_rds_cluster.restored_from_snapshot.id
  engine = var.engine
  engine_version = aws_rds_cluster.restored_from_snapshot.engine_version
  instance_class     = var.instance_class

  depends_on = [ aws_rds_cluster.restored_from_snapshot ]
}

