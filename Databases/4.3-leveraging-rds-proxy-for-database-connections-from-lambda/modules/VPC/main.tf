# Step 1: Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.sysname}-vpc"
  }
}

#Internet Gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-igw"
  }
}

#NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.sysname}-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = aws_subnet.public.id
  allocation_id = aws_eip.nat_eip.id 

  tags = {
    Name = "${var.sysname}-nat-gateway"
  }
}

resource "aws_route" "private_route_nat_gateway" {
  route_table_id = aws_route_table.ec2_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_ec2_a_cidr
  availability_zone = var.az_a 
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.sysname}-public-subnet"
  }
}

resource "aws_subnet" "subnet_ec2_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_public_cidr
  availability_zone = var.az_a 
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-EC2-subnet-A"
  }
}

resource "aws_subnet" "subnet_ec2_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_ec2_b_cidr
  availability_zone = var.az_b 
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-EC2-subnet-B"
  }
}

resource "aws_subnet" "subnet_db_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_db_a_cidr
  availability_zone = var.az_a
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-DB-subnet-A"
  }
}

resource "aws_subnet" "subnet_db_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_db_b_cidr
  availability_zone = var.az_b
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-DB-subnet-B"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-public"
  }
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}


resource "aws_route_table" "ec2_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-EC2-route-table-A"
  }
}

resource "aws_route_table" "ec2_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-EC2-route-table-B"
  }
}

resource "aws_route_table" "db_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-DB-route-table-A"
  }
}

resource "aws_route_table" "db_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-DB-route-table-B"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "ec2_a" {
  subnet_id      = aws_subnet.subnet_ec2_a.id
  route_table_id = aws_route_table.ec2_a.id
}

resource "aws_route_table_association" "ec2_b" {
  subnet_id      = aws_subnet.subnet_ec2_b.id
  route_table_id = aws_route_table.ec2_b.id
}

resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.subnet_db_a.id
  route_table_id = aws_route_table.db_a.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.subnet_db_b.id
  route_table_id = aws_route_table.db_b.id
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
resource "aws_security_group_rule" "endpoinet_ingress_https" {
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
    aws_route_table.ec2_a.id,
    aws_route_table.ec2_b.id,
  ]
}