resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.sysname}-VPC"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_a_cidr
  availability_zone = var.subnet_a_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-Subnet-A"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_b_cidr
  availability_zone = var.subnet_b_az
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-Subnet-B"
  }
}

resource "aws_route_table" "route_table_a" {
  vpc_id = aws_vpc.my_vpc.id 

  tags = {
    Name = "${var.sysname}-route-table-A"
  }
}

resource "aws_route_table_association" "route_table_association_a" {
  subnet_id = aws_subnet.subnet_a.id 
  route_table_id = aws_route_table.route_table_a.id
}

resource "aws_route_table" "route_table_b" {
  vpc_id = aws_vpc.my_vpc.id 

  tags = {
    Name = "${var.sysname}-route-table-b"
  }
}

resource "aws_route_table_association" "route_table_association_b" {
  subnet_id = aws_subnet.subnet_b.id 
  route_table_id = aws_route_table.route_table_b.id
}