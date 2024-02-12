#for testing
resource "aws_security_group" "sg_instance" {
  name   = var.security_group_name
  vpc_id = var.vpc_id
}

# エンドポイントに対する HTTPS 通信を許可
resource "aws_security_group_rule" "endpoint_ingress_https" {
  count = var.create_endpoint ? 1: 0
  security_group_id = aws_security_group.endpoint[0].id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 443
  protocol          = "tcp"
}

# インスタンスからの通信は許可
resource "aws_security_group_rule" "instance_egress_all" {
  count = var.create_endpoint ? 1: 0
  security_group_id = aws_security_group.sg_instance.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "all"
}

# エンドポイント用のセキュリティグループ
resource "aws_security_group" "endpoint" {
  count = var.create_endpoint ? 1: 0
  name   = "${var.sysname}-${var.instance_name}-endpoint"
  vpc_id = var.vpc_id
}

# ssm エンドポイント
resource "aws_vpc_endpoint" "ssm_endpoint" {
  count = var.create_endpoint ? 1: 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]
  security_group_ids = [
    aws_security_group.endpoint[0].id
  ]
  private_dns_enabled = true
}

# ssmmessages エンドポイント
resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  count = var.create_endpoint ? 1: 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [
    aws_security_group.endpoint[0].id
  ]
  private_dns_enabled = true
}

# ec2messages エンドポイント
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  count = var.create_endpoint ? 1: 0
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [var.subnet_id]

  security_group_ids = [
    aws_security_group.endpoint[0].id
  ]
  private_dns_enabled = true
}

# Amazon Linux 2 AMI
data aws_ssm_parameter "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "instance" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  availability_zone = var.availability_zone
  iam_instance_profile = var.instance_profile
  
  tags = {
    Name = "${var.sysname}"
  }
}