# Create an S3 bucket
resource "aws_s3_bucket" "source_bucket" {
  bucket = "my-source-bucket"
  acl    = "private"
}

# Create VPC, subnets, and route table
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_vpc.main.main_route_table_id
}

# Create EC2 instance with EFS filesystem attached
resource "aws_efs_file_system" "efs" {
  tags = {
    Name = "my_efs"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.subnet.id
}

resource "aws_instance" "example" {
  ami             = "ami-0c55b159cbfafe1f0" # Change this to the latest Amazon Linux 2 AMI in your region
  instance_type   = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}

# Create IAM Role
resource "aws_iam_role" "s3_role" {
  name = "S3DataSyncRole"

  assume_role_policy = file("assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "s3_ro_attach" {
  role       = aws_iam_role.s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role" "efs_role" {
  name = "EFSDataSyncRole"

  assume_role_policy = file("assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "efs_rw_attach" {
  role       = aws_iam_role.efs_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}

# Create DataSync Locations for S3 and EFS
resource "aws_datasync_location_s3" "s3_location" {
  s3_bucket_arn = aws_s3_bucket.source_bucket.arn
  s3_config {
    bucket_access_role_arn = aws_iam_role.s3_role.arn
  }
}

resource "aws_datasync_location_efs" "efs_location" {
  ec2_config {
    security_group_arns = [aws_instance.example.vpc_security_group_ids[0]]
    subnet_arn          = aws_subnet.subnet.arn
  }

  efs_file_system_arn = aws_efs_file_system.efs.arn
}

# Create DataSync Task
resource "aws_datasync_task" "sync_task" {
  destination_location_arn = aws_datasync_location_efs.efs_location.arn
  source_location_arn      = aws_datasync_location_s3.s3_location.arn
}

# Execute the task
# NOTE: Terraform doesn't have a native way to execute DataSync tasks. 
# You may need to do this step manually or automate via other methods.
