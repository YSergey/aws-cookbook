resource "aws_vpc" "main_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

# Public subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "172.16.0.0/24"
  availability_zone = var.azs[0]
  # Amazon VPC (Virtual Private Cloud) 内のサブネットでEC2インスタンスが起動したときにパブリックIPアドレスを自動的に割り当てるかどうかを制御
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "172.16.1.0/24"
  availability_zone = var.azs[1]
  map_public_ip_on_launch = true
}

# Isolated subnets
resource "aws_subnet" "isolated_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "172.16.2.0/24"
  availability_zone = var.azs[0]
}

resource "aws_subnet" "isolated_subnet_2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "172.16.3.0/24"
  availability_zone = var.azs[1]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "example-igw"
  }
}

# Route tables for public subnets (assuming a route to some internet gateway or other destination)
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Route tables for isolated subnets (no route to the internet)
resource "aws_route_table" "isolated_route_table" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table_association" "isolated_subnet_1_assoc" {
  subnet_id      = aws_subnet.isolated_subnet_1.id
  route_table_id = aws_route_table.isolated_route_table.id
}

resource "aws_route_table_association" "isolated_subnet_2_assoc" {
  subnet_id      = aws_subnet.isolated_subnet_2.id
  route_table_id = aws_route_table.isolated_route_table.id
}
