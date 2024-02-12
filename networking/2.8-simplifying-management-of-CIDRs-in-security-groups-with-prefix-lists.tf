provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnets in 2 AZs
resource "aws_subnet" "public" {
  count = 2
  cidr_block        = count.index == 0 ? "10.0.1.0/24" : "10.0.2.0/24"
  vpc_id            = aws_vpc.main.id
  map_public_ip_on_launch = true
}

# Create EC2 instances in each subnet
resource "aws_instance" "web" {
  count = 2
  ami           = "ami-0c55b159cbfafe1f0" # replace this with the latest Amazon Linux 2 LTS AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "WebServer${count.index}"
  }
}

# Security groups for each EC2 instance
resource "aws_security_group" "web_sg" {
  count = 2
  name        = "web_sg${count.index}"
  description = "Allow inbound traffic for WebServer${count.index}"
  vpc_id      = aws_vpc.main.id
}

resource "aws_security_group_rule" "web_sg_rule" {
  count = 2
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  security_group_id = aws_security_group.web_sg[count.index].id
  prefix_list = "your-prefix-list-id" # Replace this with the actual prefix list ID you create
}

# Managed Prefix List (You will need to update the CIDRs after the AWS CLI command below)
resource "aws_vpc_prefix_list" "workspaces" {
  name           = "workspaces-prefix"
  address_family = "IPv4"
  max_entries    = 5
  entry {
    cidr = "cidr_goes_here" # This will need to be updated
  }
}

# After applying the Terraform code, run the following AWS CLI commands to get the required details:

# Fetch AWS IP range JSON
# curl https://ip-ranges.amazonaws.com/ip-ranges.json -o ip-ranges.json

# Filter CIDR for Amazon WorkSpaces in us-west-2
# WORKSPACE_CIDRS=$(cat ip-ranges.json | jq -r '.prefixes[] | select(.service=="WORKSPACES" and .region=="us-west-2") | .ip_prefix')

# Update managed prefix list with WORKSPACE_CIDRS
# Use AWS CLI or Terraform to update the list

# Get your workstation's public IPv4
# MY_IP=$(curl https://checkip.amazonaws.com)

# Update managed prefix list with MY_IP
# Use AWS CLI or Terraform to update the list
