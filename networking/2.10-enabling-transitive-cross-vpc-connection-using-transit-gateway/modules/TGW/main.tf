#https://www.cdw.com/content/cdw/en/articles/cloud/multi-vpc-single-internet-egress-transit-gateway.html

resource "aws_ec2_transit_gateway" "tgw" {
    description = "example-transit-gateway"
    
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"

    tags = {
        Name = var.sysname
    }
}

# Transit GatewayにVPCをアタッチ
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_1" {
  vpc_id             = var.vpc1_id
  subnet_ids          = var.subnet1_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  depends_on = [ aws_ec2_transit_gateway.tgw ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_2" {
  vpc_id             = var.vpc2_id
  subnet_ids          = var.subnet2_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  depends_on = [ aws_ec2_transit_gateway.tgw ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_3" {
  vpc_id             = var.vpc3_id
  subnet_ids          = var.subnet3_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  depends_on = [ aws_ec2_transit_gateway.tgw ]
}

resource "aws_ec2_transit_gateway_route_table" "tgw_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "${var.sysname}-RouteTable"
  }

  depends_on = [ aws_ec2_transit_gateway.tgw ]
}

resource "aws_ec2_transit_gateway_route" "tgw_route_1" {
  destination_cidr_block = var.vpc1_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_1.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_route_table.id
}

resource "aws_ec2_transit_gateway_route" "tgw_route_2" {
  destination_cidr_block = var.vpc2_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_2.id 
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_route_table.id
}

resource "aws_ec2_transit_gateway_route" "tgw_route_3" {
  destination_cidr_block = var.vpc3_cidr
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment_3.id 
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_route_table.id
}

#行きの通信（アウトバウンド）のルートテーブル設定
resource "aws_route" "vpc2_isolated_route_to_nat" {
  route_table_id         = var.vpc2_rt
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

  depends_on = [ aws_ec2_transit_gateway_route_table.tgw_route_table  ]
}

#行きの通信（アウトバウンド）のルートテーブル設定
resource "aws_route" "vpc3_isolated_route_to_nat" {
  route_table_id         = var.vpc3_rt
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

  depends_on = [ aws_ec2_transit_gateway_route_table.tgw_route_table  ]
}

#戻りの通信（インバウンド）のルートテーブル設定
resource "aws_route" "nat_to_tgw_vpc2" {
  route_table_id         = var.vpc1_public_rt
  destination_cidr_block = var.vpc2_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

  depends_on = [ aws_ec2_transit_gateway_route_table.tgw_route_table  ]
}

#戻りの通信（インバウンド）のルートテーブル設定
resource "aws_route" "nat_to_tgw_vpc3" {
  route_table_id         = var.vpc1_public_rt
  destination_cidr_block = var.vpc3_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id

  depends_on = [ aws_ec2_transit_gateway_route_table.tgw_route_table  ]
}

