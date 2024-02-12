# https://www.cdw.com/content/cdw/en/articles/cloud/multi-vpc-single-internet-egress-transit-gateway.html
# https://aws.plainenglish.io/terraform-to-build-aws-transit-gateway-and-spoke-vpcs-df79bd6906c3
# https://dev.classmethod.jp/articles/tgw-outbound-aggregation-2022/#toc-9

# Create a Transit Gateway
resource "aws_ec2_transit_gateway" "tgw" {
    default_route_table_association = "disable"
#for security reasons, we dont want to have attached VPCs to use the default route table
    default_route_table_propagation = "disable"
#for security reasons, we dont want to have attached VPCs to propogate their networks to the route tables
    auto_accept_shared_attachments = "enable"
    tags = {
      Name = "tgw"
    }
}

# Create Transit Gateway Attachments for VPC1, VPC2 and VPC3
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_1_attachment" {
  vpc_id             = var.vpc1_id
  subnet_ids         = var.subnet1_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_2_attachment" {
  vpc_id             = var.vpc2_id
  subnet_ids         = var.subnet2_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_3_attachment" {
  vpc_id             = var.vpc3_id
  subnet_ids         = var.subnet3_ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

# Create a custom Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "custom_tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
}

# Associate the VPCs with the custom Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table_association" "vpc1_custom_tgw_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.custom_tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc2_custom_tgw_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_2_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.custom_tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc3_custom_tgw_association" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_3_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.custom_tgw_rt.id

}

# Routes for Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route" "vpc1_route_tgw" {
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc_1_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.custom_tgw_rt.id
}

# Routes for VPCs
# VPC1 Public Route Table
# resource "aws_route" "vpc1_public_route" {
#   route_table_id            = var.public_route_table_1_id
#   destination_cidr_block    = "0.0.0.0/0"
#   nat_gateway_id            = var.nat_gateway_1_id # Assuming you have a NAT Gateway for VPC1
# }

# VPC2 and VPC3 Private Route Tables
resource "aws_route" "vpc2_private_route" {
  route_table_id            = var.isolated_route_table_2_id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "vpc3_private_route" {
  route_table_id            = var.isolated_route_table_3_id
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = aws_ec2_transit_gateway.tgw.id
}
