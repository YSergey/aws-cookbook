#for testing
resource "aws_security_group" "sg_instance" {
  name   = var.security_group_name
  vpc_id = var.vpc_id
}

# インスタンスからの通信は許可
resource "aws_security_group_rule" "instance_egress_all" {
  security_group_id = aws_security_group.sg_instance.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "all"
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

  #-F'"'は、フィールド区切り文字をダブルクオート(")に設定します。これは、JSONから値を抽出するために使用
  #/region/ {print $4}は、regionを含む行を検索し、その行の4番目のフィールド（この場合、リージョン名）を出力
  user_data = <<-EOF
              #!/bin/bash
              export AWS_DEFAULT_REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F'"' '/region/ {print $4}')
              EOF
  
  tags = {
    Name = "${var.sysname}-instance"
  }
}

# Grant EC2 instance security group access to MySQL port
resource "aws_security_group_rule" "ec2_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_instance.id
  security_group_id        = var.db_security_group_id
}
