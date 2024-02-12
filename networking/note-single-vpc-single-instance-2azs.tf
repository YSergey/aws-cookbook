provider "aws" {
  region = "us-west-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "my_subnet_1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1a"
  tags = {
    Name = "my_subnet_1"
  }
}

resource "aws_subnet" "my_subnet_2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "my_subnet_2"
  }
}

resource "aws_instance" "my_instance_1" {
  ami             = "ami-0c55b159cbfafe1f0"  # Replace with your AMI ID
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet_1.id
  tags = {
    Name = "my_instance_1"
  }
}

resource "aws_instance" "my_instance_2" {
  ami             = "ami-0c55b159cbfafe1f0"  # Replace with your AMI ID
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet_2.id
  tags = {
    Name = "my_instance_2"
  }
}
