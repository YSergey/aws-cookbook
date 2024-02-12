# Create VPC 1
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc-1"
  }
}

resource "aws_subnet" "subnet1_vpc1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.azs[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "example-subnet-1-1"
  }
}

resource "aws_subnet" "subnet2_vpc1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.azs[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "example-subnet-1-2"
  }
}

resource "aws_route_table" "example_route_table_1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "example-route-table-1"
  }
}

resource "aws_route_table_association" "example_route_table_association_1" {
  subnet_id      = aws_subnet.subnet1_vpc1.id
  route_table_id = aws_route_table.example_route_table_1.id
}

# Create VPC 2
resource "aws_vpc" "vpc2" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc-2"
  }
}

resource "aws_subnet" "subnet1_vpc2" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.1.1.0/24"
  availability_zone = var.azs[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "example-subnet-2-1"
  }
}

resource "aws_subnet" "subnet2_vpc2" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = "10.1.2.0/24"
  availability_zone = var.azs[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "example-subnet-2-2"
  }
}

resource "aws_route_table" "example_route_table_2" {
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "example-route-table-2"
  }
}

resource "aws_route_table_association" "example_route_table_association_2" {
  subnet_id      = aws_subnet.subnet1_vpc2.id
  route_table_id = aws_route_table.example_route_table_2.id
}

# Peering Connection between VPC1 and VPC2

resource "aws_vpc_peering_connection" "vpc1_to_vpc2" {
  peer_vpc_id = aws_vpc.vpc2.id
  vpc_id      = aws_vpc.vpc1.id

  auto_accept = true

  tags = {
    Name = "VPC1 to VPC2 Peering Connection"
  }
}

# Update route tables to direct traffic for peered VPCs

resource "aws_route" "route_vpc1" {
  route_table_id         = aws_route_table.example_route_table_1.id
  destination_cidr_block = aws_vpc.vpc2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
}

resource "aws_route" "route_vpc2" {
  route_table_id         = aws_route_table.example_route_table_2.id
  destination_cidr_block = aws_vpc.vpc1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc1_to_vpc2.id
}

# Security group rule to allow ICMPv4 from VPC1 instance to VPC2 instance
resource "aws_security_group_rule" "allow_icmp" {
  type        = "ingress"
  from_port   = -1 # ICMP doesn’t have a port
  to_port     = -1 # ICMP doesn’t have a port
  protocol    = "icmp"
  cidr_blocks = [aws_vpc.vpc1.cidr_block]
  security_group_id = aws_security_group.sg_instance_2.id
}

# Amazon Linux 2 AMI
data aws_ssm_parameter "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "instance_vpc1" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1_vpc1.id
  availability_zone = var.azs[0]
  
  iam_instance_profile = var.instance_name
  vpc_security_group_ids = [aws_security_group.sg_instance_1.id]

  tags = {
    Name = "Instance in VPC1"
  }
}

resource "aws_instance" "instance_vpc2" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet1_vpc2.id
  availability_zone = var.azs[0]

  vpc_security_group_ids = [aws_security_group.sg_instance_2.id]

  tags = {
    Name = "Instance in VPC2"
  }
}


resource "aws_security_group" "sg_instance_1" {
  name   = "instance-sg"
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_security_group" "sg_instance_2" {
  name = "instance-2"
  vpc_id = aws_vpc.vpc2.id
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

resource "aws_security_group_rule" "instance_2_egress_all" {
  security_group_id = aws_security_group.sg_instance_2.id
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
  vpc_id = aws_vpc.vpc1.id
}

# ssm エンドポイント
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = aws_vpc.vpc1.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.subnet1_vpc1.id]
  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ssmmessages エンドポイント
resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  vpc_id            = aws_vpc.vpc1.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.subnet1_vpc1.id]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ec2messages エンドポイント
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id            = aws_vpc.vpc1.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.subnet1_vpc1.id]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
}

#  S3 endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc1.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.example_route_table_1.id]
}