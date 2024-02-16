#for testing
resource "aws_security_group" "sg_instance" {
  name   = "${var.sysname}-ec2-sg"
  vpc_id = var.vpc_id

  egress {
    from_port = 0 
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Amazon Linux 2 AMI
data aws_ssm_parameter "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "instance" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  availability_zone = var.availability_zone
  iam_instance_profile = aws_iam_instance_profile.instance.name
  
  tags = {
    Name = "${var.sysname}-${var.instance_name}"
  }
}