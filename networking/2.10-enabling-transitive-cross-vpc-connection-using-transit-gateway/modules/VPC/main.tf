
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true 
  enable_dns_support = true 

  tags = {
    Name = "${var.sysname}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  count = var.create_igw ? 1 : 0
  tags = {
    Name = "${var.sysname}-internet-gateway-attached"
  }
}

resource "aws_eip" "eip" {
  count = var.create_igw ? 1 : 0
  domain = "vpc"
}

resource "aws_nat_gateway" "public_1_nat_gateway" {
  count = var.create_igw ? 1 : 0
  allocation_id = aws_eip.eip[0].id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${var.sysname}-NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true 

  tags = {
    Name = "${var.sysname}-public-subnet-1"
  }
}

resource "aws_route_table" "public_route_table_1" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    Name = "${var.sysname}-public-route-table-1-1"
  }
}

resource "aws_route" "public_route_1" {
  count                  = var.create_igw ? 1 : 0
  route_table_id         = aws_route_table.public_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id 
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table_1.id
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.vpc.id 
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = true 

  tags = {
    Name = "${var.sysname}-public-subnet-2"
  }
}

resource "aws_route_table" "public_route_table_2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.sysname}-public-route-table-2"
  }
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table_2.id
}

resource "aws_route" "public_route_2" {
  count                  = var.create_igw ? 1 : 0
  route_table_id = aws_route_table.public_route_table_2.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw[0].id
}

resource "aws_subnet" "isolated_subnet_1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.isolated_subnet_1_cidr
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-isolated-subnet-1"
  }
}

resource "aws_route_table" "isolated_route_table_1" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    Name = "${var.sysname}-isolated-route-table-1"
  }
}

resource "aws_route_table_association" "isolated_assoc_1" {
  subnet_id = aws_subnet.isolated_subnet_1.id
  route_table_id = aws_route_table.isolated_route_table_1.id
}

resource "aws_route" "isolated_route_1" {
  route_table_id         = aws_route_table.isolated_route_table_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.create_igw ? aws_nat_gateway.public_1_nat_gateway[0].id : var.transit_gateway_id
}

resource "aws_subnet" "isolated_subnet_2" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.isolated_subnet_2_cidr
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-isolated-subnet-2"
  }
}

resource "aws_route_table" "isolated_route_table_2" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    Name = "${var.sysname}-isolated-route-table-2"
  }
}

resource "aws_route_table_association" "isolated_assoc_1_1" {
  subnet_id = aws_subnet.isolated_subnet_1.id
  route_table_id = aws_route_table.isolated_route_table_1.id
}