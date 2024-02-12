
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true 
  enable_dns_support = true 

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.azs[0] 
  map_public_ip_on_launch = true

  tags = {
    Name = "example-public-subnet-1"
  }
}

resource "aws_subnet" "isolated_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.azs[0] 
  map_public_ip_on_launch = false

  tags = {
    Name = "example-isolated-subnet-1"
  }
}

resource "aws_subnet" "isolated_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = var.azs[1] 
  map_public_ip_on_launch = false

  tags = {
    Name = "example-isolated-subnet-2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "example-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "isolated" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "example-isolated-route-table"
  }
}

resource "aws_route_table_association" "isolated_1" {
  subnet_id      = aws_subnet.isolated_1.id
  route_table_id = aws_route_table.isolated.id
}

resource "aws_route_table_association" "isolated_2" {
  subnet_id      = aws_subnet.isolated_2.id
  route_table_id = aws_route_table.isolated.id
}

# VPC Endpoint for S3
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RestrictToOneBucket",
      "Principal": "*",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
      ],
      "Effect": "Allow",
      "Resource": [
                    "arn:aws:s3:::${var.bucket_name}",
                    "arn:aws:s3:::${var.bucket_name}/*"
                  ]
    }
  ]})

  tags = {
    Name = "s3_endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
    vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
    route_table_id  = aws_route_table.isolated.id
}

#for testing
resource "aws_security_group" "sg_instance_1" {
  name   = "instance-sg"
  vpc_id = aws_vpc.main.id
}

# エンドポイントに対する HTTPS 通信を許可
resource "aws_security_group_rule" "endpoint_ingress_https" {
  security_group_id = aws_security_group.endpoint.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

# インスタンスからの通信は許可
resource "aws_security_group_rule" "instance_egress_all" {
  security_group_id = aws_security_group.sg_instance_1.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "all"
}

# エンドポイント用のセキュリティグループ
resource "aws_security_group" "endpoint" {
  name   = "endpoint"
  vpc_id = aws_vpc.main.id
}

# ssm エンドポイント
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.isolated_1.id]
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
  subnet_ids        = [aws_subnet.isolated_1.id]

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
  subnet_ids        = [aws_subnet.isolated_1.id]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# Amazon Linux 2 AMI
data aws_ssm_parameter "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "example_instance_1" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.isolated_1.id
  availability_zone = var.azs[0]
  
  iam_instance_profile = var.instance_profile_name

  vpc_security_group_ids = [
    aws_security_group.sg_instance_1.id
  ]
  
  tags = {
    Name = "example-instance-1"
  }
}