# Step 1: Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.sysname}-vpc"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_a_cidr
  availability_zone = var.az_a 
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-subnet-A"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_b_cidr
  availability_zone = var.az_b 
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.sysname}-subnet-B"
  }
}

# resource "aws_internet_gateway" "IGW" {
#   vpc_id = aws_vpc.main.id 

#   tags = {
#     Name = "${var.sysname}-IGW"
#   }
# }

resource "aws_route_table" "route_table_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-route-table-A"
  }
}

# resource "aws_route" "route_a" {
#   route_table_id = aws_route_table.route_table_a.id 
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.IGW.id
# }

resource "aws_route_table" "route_table_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.sysname}-route-table-B"
  }
}

# resource "aws_route" "route_b" {
#   route_table_id = aws_route_table.route_table_b.id 
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.IGW.id
# }


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.route_table_a.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.route_table_b.id
}
