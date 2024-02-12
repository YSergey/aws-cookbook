resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example_subnet" {
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.azs[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "example-subnet"
  }
}

resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-route-table"
  }
}

resource "aws_route_table_association" "example_route_table_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

resource "aws_security_group" "sg_instance_1" {
  name   = "instance-sg"
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_security_group" "sg_instance_2" {
  name = "instance-2"
  vpc_id = aws_vpc.example_vpc.id
}

# エンドポイントに対する HTTPS 通信を許可
resource "aws_security_group_rule" "endpoint_ingress_https" {
  security_group_id = aws_security_group.endpoint.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 443
  protocol          = "tcp"
}

# インスタンスからの通信は全て許可
resource "aws_security_group_rule" "instance_egress_all" {
  security_group_id = aws_security_group.sg_instance_1.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "all"
}

resource "aws_security_group_rule" "sg_instance_1_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = aws_security_group.sg_instance_1.id
  source_security_group_id = aws_security_group.sg_instance_2.id
}

resource "aws_security_group_rule" "sg_instance_2_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  security_group_id = aws_security_group.sg_instance_2.id
  source_security_group_id = aws_security_group.sg_instance_1.id
}

# エンドポイント用のセキュリティグループ
resource "aws_security_group" "endpoint" {
  name   = "endpoint"
  vpc_id = aws_vpc.example_vpc.id
}

# ssm エンドポイント
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.example_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.example_subnet.id]
  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ssmmessages エンドポイント
resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  vpc_id            = aws_vpc.example_vpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.example_subnet.id]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ec2messages エンドポイント
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id            = aws_vpc.example_vpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.example_subnet.id]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
}

# Adding VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.example_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.example_route_table.id]
}

# Amazon Linux 2 AMI
data aws_ssm_parameter "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "example_instance_1" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  availability_zone = var.azs[0]
  
  iam_instance_profile = var.instance_name
  vpc_security_group_ids = [
    aws_security_group.sg_instance_1.id,
    aws_security_group.sg_instance_1.id
    ]
  
  tags = {
    Name = "example-instance-1"
  }
}

resource "aws_instance" "example_instance_2" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_instance_1.id]

  tags = {
    Name = "example-instance-2"
  }
}
