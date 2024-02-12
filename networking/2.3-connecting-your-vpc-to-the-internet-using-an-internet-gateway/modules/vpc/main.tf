
resource "aws_vpc" "example_vpc" {
  cidr_block = "172.16.0.0/16"
  enable_dns_support = true 
  enable_dns_hostnames = true 

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example_vpc.id 
  tags = {
    Name = "example-igw"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.example_vpc.id 
  cidr_block = "172.16.0.0/24"
  availability_zone = var.azs[0]

  tags = {
    Name = "example-vpc-subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.example_vpc.id 
  cidr_block = "172.16.1.0/24"
  availability_zone = var.azs[1]

  tags = {
    Name = "example-vpc-subnet-2"
  }
}

resource "aws_route_table" "route_table_1" {
  vpc_id = aws_vpc.example_vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "example-route-table-1"
  }
}

resource "aws_route_table" "route_table_2" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "example-route-table-2"
  }
}

resource "aws_route_table_association" "subnet_1_assoc" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table_1.id
}

resource "aws_route_table_association" "subnet_2_assoc" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.route_table_2.id
}

resource "aws_instance" "example" {
  ami = "ami-0044a0897b53acfb6"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_1.id

  tags = {
    Name = "example"
  }
}

resource "aws_eip" "example" {
  instance = aws_instance.example.id 
  tags = {
    Name = "example"
  }
}

resource "aws_eip_association" "example" {
  instance_id = aws_instance.example.id 
  allocation_id = aws_eip.example.id
}