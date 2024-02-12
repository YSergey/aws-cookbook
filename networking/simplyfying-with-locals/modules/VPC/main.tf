
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true 
  enable_dns_support = true 

  tags = {
    Name = "${var.sysname}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.sysname}-internet-gateway-attached"
  }
}

resource "aws_subnet" "public-subnet-1-1" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true 

  tags = {
    Name = "${var.sysname}-public-subnet-1"
  }
}

resource "aws_network_interface" "public_subnet_1_1_eni" {
  subnet_id = aws_subnet.public-subnet-1-1.id

  tags = {
    Name = "${var.sysname}-public_subnet_1_1_eni"
  }
}


resource "aws_route_table" "public_route_table_1_1" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    Name = "${var.sysname}-public-route-table-1-1"
  }
}

resource "aws_route" "public_route_1" {
  route_table_id         = aws_route_table.public_route_table_1_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc_1_1" {
  subnet_id = aws_subnet.public-subnet-1-1.id
  route_table_id = aws_route_table.public_route_table_1_1.id
}

resource "aws_subnet" "isolated-subnet-1-1" {
  vpc_id = aws_vpc.vpc.id 
  cidr_block = var.isolated-subnet_1_cidr
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = false 

  tags = {
    Name = "${var.sysname}-isolated-subnet-1"
  }
}

resource "aws_network_interface" "isolated_subnet_1_1_eni" {
  subnet_id = aws_subnet.isolated-subnet-1-1.id

  tags = {
    Name = "${var.sysname}-isolated_subnet_1_1_eni"
  }
}

resource "aws_route_table" "isolated_route_table_1_1" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    Name = "${var.sysname}-isolated-route-table-1-1"
  }
}

resource "aws_route_table_association" "isolated_assoc_1_1" {
  subnet_id = aws_subnet.isolated-subnet-1-1.id
  route_table_id = aws_route_table.isolated_route_table_1_1.id
}

resource "aws_route" "private_route_nat_gateway_1" {
  route_table_id = aws_route_table.isolated_route_table_1_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.public_nat_gw.id
}


resource "aws_subnet" "public-subnet-1-2" {
  vpc_id = aws_vpc.vpc.id 
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = true 

  tags = {
    Name = "${var.sysname}-public-subnet-2"
  }
}

resource "aws_route_table" "public_route_table_1_2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.sysname}-public-route-table-1-2"
  }
}

resource "aws_route_table_association" "public_assoc_1_2" {
  subnet_id = aws_subnet.public-subnet-1-2.id
  route_table_id = aws_route_table.public_route_table_1_2.id
}

resource "aws_route" "public_route_2" {
  route_table_id = aws_route_table.public_route_table_1_2.id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_subnet" "isolated-subnet-1-2" {
  vpc_id = aws_vpc.vpc.id 
  cidr_block = var.isolated-subnet_2_cidr
  availability_zone = var.availability_zone_2
  map_public_ip_on_launch = false 

  tags = {
    Name = "${var.sysname}-isolated-subnet-2"
  }
}

resource "aws_route_table" "isolated_route_table_1_2" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    Name = "${var.sysname}-isolated-route-table-1-2"
  }
}

resource "aws_route_table_association" "isolated_assoc_1_2" {
  subnet_id = aws_subnet.isolated-subnet-1-2.id
  route_table_id = aws_route_table.isolated_route_table_1_2.id
}

resource "aws_network_interface" "isolated_subnet_1_2_eni" {
  subnet_id = aws_subnet.isolated-subnet-1-2.id

  tags = {
    Name = "${var.sysname}-isolated_subnet_1_2_eni"
  }
}

resource "aws_eip" "public_nat_gw_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.sysname}-public_nat_gw_eip"
  }
}

resource "aws_nat_gateway" "public_nat_gw" {
  subnet_id = aws_subnet.public-subnet-1-1.id 
  allocation_id = aws_eip.public_nat_gw_eip.id  

  tags = {
    Name = "${var.sysname}-public-NAT-gateway-1-1"
  }
}
