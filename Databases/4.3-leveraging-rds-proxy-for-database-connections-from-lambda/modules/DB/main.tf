# Use AWS Secrets Manager to generate a complex password
resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.sysname}-db-credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  # ユーザーネームとパスワードを含むJSONオブジェクトを指定
  secret_string = jsonencode({
    username = "${var.master_username}"
    password = "${random_password.password.result}"
    engine = "${var.engine}",
    # host = "${aws_db_instance.rds_instance.address}",
    port = 3306,
    # dbInstanceIdentifier = "${aws_db_instance.rds_instance.id}"
  })
}

resource "random_password" "password" {
  length           = 16
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
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.sysname}-aurora-db-sg"
  }
}

resource "aws_security_group" "db_proxy_sg" {
  name        = "${var.sysname}-db-proxy-sg"
  description = "Allow inbound traffic for RDS Proxy"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.sysname}-aurora-db-proxy-sg"
  }
}

#Lambda -> RDS Proxy
resource "aws_security_group_rule" "lambda_to_rds_proxy" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = var.lambda_sg_id
  security_group_id = aws_security_group.db_proxy_sg.id
}

#EC2 -> RDS Proxy 
resource "aws_security_group_rule" "ec2_to_rds_proxy" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = var.ec2_sg_id
  security_group_id = aws_security_group.db_proxy_sg.id
}

# RDS Proxy -> RDS
resource "aws_security_group_rule" "rds_proxy_to_rds" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = aws_security_group.db_proxy_sg.id
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

# resource "aws_db_instance" "rds_instance" {
#   allocated_storage    = 8
#   storage_type         = "gp2"
#   engine               = var.engine
#   engine_version       = var.engine_version
#   instance_class       = var.instance_class
#   username             = var.master_username
#   password             = random_password.password.result
#   db_subnet_group_name = aws_db_subnet_group.aurora_db_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.db_sg.id]

#   port                 = 3306
#   apply_immediately    = true

#   skip_final_snapshot = true

#   iam_database_authentication_enabled = false

# }

# RDS Proxy 
resource "aws_db_proxy" "rds_proxy" {
  name                   = "db-proxy"
  debug_logging          = true
  engine_family          = "MYSQL"
  idle_client_timeout    = 60
  require_tls            = true
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_security_group_ids = [ aws_security_group.db_proxy_sg.id ] 
  vpc_subnet_ids         = [ var.subnet_a_id, var.subnet_b_id ] 

  auth {
    auth_scheme = "SECRETS"
    iam_auth   = "REQUIRED"
    # iam_auth = "DISABLED"
    secret_arn  = "${aws_secretsmanager_secret.db_secret.arn}"
  }

  depends_on = [ 
    aws_iam_role.rds_proxy_role,
    aws_secretsmanager_secret.db_secret,
    # aws_db_instance.rds_instance
  ]
}

# resource "aws_db_proxy_endpoint" "example" {
#   db_proxy_name          = aws_db_proxy.rds_proxy.name
#   db_proxy_endpoint_name = "example"
#   vpc_subnet_ids         = [ var.subnet_a_id, var.subnet_b_id ]
#   target_role            = "READ_ONLY"

#   depends_on = [ aws_db_proxy.rds_proxy ]
# }

resource "aws_db_proxy_default_target_group" "rds_proxy_tg" {
  db_proxy_name = aws_db_proxy.rds_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 90  # 接続の借用がタイムアウトになるまでの時間(秒)
    max_connections_percent      = 90  # プロキシによって許可される最大接続数の割合
    max_idle_connections_percent = 50  # アイドル状態の接続が占めることができる最大割合
    session_pinning_filters      = [] # セッションピンニングをトリガする変数
  }

  depends_on = [ aws_db_proxy.rds_proxy ]
}

resource "aws_db_proxy_target" "rds_proxy_target" {
  db_proxy_name = aws_db_proxy.rds_proxy.name
  target_group_name = aws_db_proxy_default_target_group.rds_proxy_tg.name
  db_cluster_identifier = aws_rds_cluster.aurora_cluster.id #クラスターに直接接続する場合
  # db_instance_identifier = aws_db_instance.rds_instance.identifier

  depends_on = [ 
    aws_rds_cluster.aurora_cluster,
    aws_rds_cluster_instance.rds_instance,
    aws_db_proxy.rds_proxy
    ]
}
