    # Create a VPC and associated resources.
    # Setup an EC2 instance in the VPC.
    # Configure AWS Backup to backup the EC2 instance.
    # (Manually) Copy the backup to another region.
    # Restore the EC2 instance in the destination region using the copied backup.

provider "aws" {
  region = "us-west-1" # change to your source region
}

# Step 1: Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1a" # Adjust based on your region
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1b" # Adjust based on your region
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "allow_alp" {
  vpc_id = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

# Step 2: Setup an EC2 instance in the VPC
resource "aws_instance" "my_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Update this with the correct AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id
  security_groups = [aws_security_group.allow_all.name]

  tags = {
    Name = "MyInstance"
  }
}

# Step 3: Configure AWS Backup to backup the EC2 instance

resource "aws_backup_vault" "main" {
  name = "MyBackupVault"
}

resource "aws_backup_plan" "main" {
  name = "MyBackupPlan"

  rule {
    rule_name         = "Main"
    target_vault_name = aws_backup_vault.main.name
    schedule          = "cron(0 12 * * ? *)"

    lifecycle {
      delete_after = 14
    }
  }

}

resource "aws_backup_selection" "main" {
  name             = "MainSelection"
  plan_id   = aws_backup_plan.main.id
  iam_role_arn     = "arn:aws:iam::123456789012:role/service-role/AWSBackupDefaultServiceRole" # Modify with correct ARN

  resources = [aws_instance.my_instance.arn]
}
