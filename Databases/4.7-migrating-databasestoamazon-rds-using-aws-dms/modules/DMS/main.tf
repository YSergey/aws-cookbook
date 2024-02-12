# Security group for DMS to access source and target databases
resource "aws_security_group" "dms_sg" {
  name        = "DMS-SG"
  description = "Allow inbound traffic for DMS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Better to restrict to your IP or range
  }
}

# IAM Role for DMS to interact with other AWS services
resource "aws_iam_role" "dms_vpc_role" {
  name = "dms-vpc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "dms.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms_vpc_role_attach" {
  role       = aws_iam_role.dms_vpc_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}

# DMS Replication Subnet Group
resource "aws_dms_replication_subnet_group" "dms_rep_subnet_group" {
  replication_subnet_group_id          = "dms-rep-subnet-group"
  replication_subnet_group_description = "DMS replication subnet group"
  subnet_ids                           = [ var.subnet_a_id, var.subnet_b_id ]
}

# DMS Replication Instance
resource "aws_dms_replication_instance" "dms_rep_instance" {
  replication_instance_id      = "tf-test-dms-replication-instance"
  replication_instance_class   = var.instance_class
  allocated_storage            = 5
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms_rep_subnet_group.replication_subnet_group_id
  vpc_security_group_ids       = [ aws_security_group.dms_sg.id ]
}


resource "aws_dms_endpoint" "source" {
  database_name          = var.source_db_name
  endpoint_id            = var.source_db_endpoint_identifer
  endpoint_type          = "source"
  engine_name            = "mysql"
  password               = var.source_db_password # get from environment variable
  port                   = 3306
  server_name            = var.source_server_name
  username               = var.source_db_username
  ssl_mode               = "none"
}

resource "aws_dms_endpoint" "target" {
  database_name          = var.target_db_name
  endpoint_id            = var.target_db_endpoint_identifer
  endpoint_type          = "target"
  engine_name            = "mysql"
  password               = var.target_db_password # get from environment variable
  port                   = 3306
  server_name            = var.target_server_name
  username               = var.target_db_username
  ssl_mode               = "none"
}

resource "aws_dms_replication_task" "migration_task" {
  migration_type            = "full-load"
  table_mappings            = file(var.file_path) # Define your table mappings in this JSON
  replication_task_id       = "test-dms-replication-task-tf"
  replication_instance_arn  = aws_dms_replication_instance.dms_rep_instance.replication_instance_arn
  source_endpoint_arn      = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target.endpoint_arn
#   replication_task_settings = file("settings.json") # Define your task settings in this JSON
}

