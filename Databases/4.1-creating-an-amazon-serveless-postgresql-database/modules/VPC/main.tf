# Step 1: Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.sysname}-vpc"
  }
}

#EC2のサブネット
resource "aws_subnet" "subnet_ec2_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_ec2_a_cidr
  availability_zone = var.az_a 
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-subnet-EC2-A"
  }
}

resource "aws_subnet" "subnet_ec2_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_ec2_b_cidr
  availability_zone = var.az_b 
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-subnet-EC2-B"
  }
}

#DBのサブネット
resource "aws_subnet" "subnet_db_a" {
  vpc_id = aws_vpc.main.id 
  cidr_block = var.subnet_db_a_cidr 
  availability_zone = var.az_a 
  map_public_ip_on_launch = false 

  tags = {
    Name = "${var.sysname}-subnet-DB-A"
  }
}

resource "aws_subnet" "subnet_db_b" {
  vpc_id = aws_vpc.main.id 
  cidr_block = var.subnet_db_b_cidr
  availability_zone = var.az_b
  map_public_ip_on_launch = false 

  tags = {
    Name = "${var.sysname}-subnet-DB-B"
  }
}

#今回はデモ用のため、ルートテーブルを１つで管理する
resource "aws_route_table" "ec2_main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "ec2_a" {
  subnet_id      = aws_subnet.subnet_ec2_a.id
  route_table_id = aws_route_table.ec2_main.id
}

resource "aws_route_table_association" "ec2_b" {
  subnet_id      = aws_subnet.subnet_ec2_b.id
  route_table_id = aws_route_table.ec2_main.id
}

resource "aws_route_table" "db_main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "db_a" {
  subnet_id = aws_subnet.subnet_db_a.id 
  route_table_id = aws_route_table.db_main.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id = aws_subnet.subnet_db_b.id 
  route_table_id = aws_route_table.db_main.id
}

# エンドポイント用のセキュリティグループ
resource "aws_security_group" "endpoint" {
  name   = "${var.sysname}-endpoint"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-endpoint"
  }
}

# エンドポイントに対する HTTPS 通信を許可
resource "aws_security_group_rule" "endpoint_ingress_https" {
  security_group_id = aws_security_group.endpoint.id
  type = "ingress"
  cidr_blocks      = [ aws_vpc.main.cidr_block ]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

# ssm エンドポイント
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ aws_subnet.subnet_ec2_a.id, aws_subnet.subnet_ec2_b.id ]
  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ssmmessages エンドポイント
resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ aws_subnet.subnet_ec2_a.id, aws_subnet.subnet_ec2_b.id ]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ec2messages エンドポイント
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ aws_subnet.subnet_ec2_a.id, aws_subnet.subnet_ec2_b.id ]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

data "aws_iam_policy_document" "vpc_endpoint" {
  statement {
    effect    = "Allow"
    actions   = [ "*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  route_table_ids = [
    aws_route_table.ec2_main.id
  ]
}