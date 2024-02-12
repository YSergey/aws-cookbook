# Step 1: Create VPC
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  tag_name = "${var.sysname}-vpc"
}

#subnet
module "subnet" {
  source = "./modules/subnet"
  count = 5
  vpc_id = module.vpc.vpc_id
  subnet_cidr = var.subnets_variable[count.index].cidr
  az = var.subnets_variable[count.index].az
  map_public_on_launch = var.subnets_variable[count.index].map_public_ip_on_launch
  tag_name = "${var.sysname}-${var.subnets_variable[count.index].subnet_name}"
}

#route_table
module "route_table" {
    source = "./modules/route_table"
    count = 5
    vpc_id = module.vpc.vpc_id
    subnet_id = module.subnet[count.index].subnet_id
    tag_name = "${var.sysname}-${var.route_table_variable[count.index].table_name}"
}

#Internet Gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.sysname}-igw"
  }
}

resource "aws_route" "public_route" {
  route_table_id = module.route_table[0].route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.sysname}-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = module.subnet[0].subnet_id
  allocation_id = aws_eip.nat_eip.id 

  tags = {
    Name = "${var.sysname}-nat-gateway"
  }
}

resource "aws_route" "private_route_nat_gateway" {
  route_table_id = module.route_table[1].route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

# エンドポイントに対する HTTPS 通信を許可
resource "aws_security_group_rule" "endpoint_ingress_https" {
  security_group_id = aws_security_group.endpoint.id
  type              = "ingress"
  cidr_blocks       = [ module.vpc.vpc_cidr ]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

# エンドポイント用のセキュリティグループ
resource "aws_security_group" "endpoint" {
  name   = "${var.sysname}-endpoint"
  vpc_id = module.vpc.vpc_id
}

# ssm エンドポイント
resource "aws_vpc_endpoint" "ssm_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ module.subnet[1].subnet_id, module.subnet[2].subnet_id ]
  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ssmmessages エンドポイント
resource "aws_vpc_endpoint" "ssmmessages_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ module.subnet[1].subnet_id, module.subnet[2].subnet_id ]

  security_group_ids = [
    aws_security_group.endpoint.id
  ]
  private_dns_enabled = true
}

# ec2messages エンドポイント
resource "aws_vpc_endpoint" "ec2messages_endpoint" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [ module.subnet[1].subnet_id, module.subnet[2].subnet_id ]

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
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  route_table_ids = [
    module.route_table[1].route_table_id,
    module.route_table[2].route_table_id,
  ]
}
