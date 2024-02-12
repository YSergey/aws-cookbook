
resource "aws_vpc" "example_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = true 
  enable_dns_hostnames = true 

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.example_vpc.id 
  cidr_block = "172.16.0.0/24"
  availability_zone = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.example_vpc.id 
  cidr_block = "172.16.1.0/24"
  availability_zone = var.azs[1] 

  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "isolated_subnet_1" {
  vpc_id = aws_vpc.example_vpc.id 
  cidr_block = "172.16.2.0/24"
  availability_zone = var.azs[0] 

  tags = {
    Name = "isolated-subnet-1"
  }
}

resource "aws_subnet" "isolated_subnet_2" {
  vpc_id = aws_vpc.example_vpc.id 
  cidr_block = "172.16.3.0/24"
  availability_zone = var.azs[1] 

  tags = {
    Name = "isolated-subnet-2"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "example-nat-eip"
  }
}

resource "aws_route_table" "isolated_route_table_1" {
  vpc_id = aws_vpc.example_vpc.id 

  tags = {
    Name = "isolated-route-table-1"
  }
}

resource "aws_route_table" "isolated_route_table_2" {
  vpc_id = aws_vpc.example_vpc.id 

  tags = {
    Name = "isolated-route-table-2"
  }
}

resource "aws_route_table_association" "isolated_route_1" {
  subnet_id = aws_subnet.isolated_subnet_1.id 
  route_table_id = aws_route_table.isolated_route_table_1.id
}

resource "aws_route_table_association" "isolated_route_2" {
  subnet_id = aws_subnet.isolated_subnet_2.id
  route_table_id = aws_route_table.isolated_route_table_2.id
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example_vpc.id 

  tags = {
    Name = "example-igw"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  subnet_id = aws_subnet.public_subnet_1.id 
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "nat-gateway-1"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_vpc.example_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}


resource "aws_route" "private_route_nat_gateway_1" {
  route_table_id = aws_route_table.isolated_route_table_1.id 
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway_1.id 
}

resource "aws_route" "private_route_nat_gateway_2" {
  route_table_id = aws_route_table.isolated_route_table_2.id 
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_instance" "example" {
  ami           = "ami-0044a0897b53acfb6"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.isolated_subnet_1.id
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = "example"
  }

  depends_on = [ aws_iam_role_policy_attachment.ssm_attachment ]
}
