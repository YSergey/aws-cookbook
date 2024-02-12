resource "aws_efs_file_system" "my_efs" {
  creation_token = "my-efs"

  tags = {
    Name = "MyEFS"
  }
}

resource "aws_security_group" "efs_sg" {
  name   = "efs_sg"
  vpc_id = var.vpc_id

  # EFSにアクセスするためのインバウンドルール
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [ var.sg_instance_id, var.lambda_sg_id ]  # EC2インスタンスのセキュリティグループ
  }

  # 必要に応じて、EFSからのアウトバウンドルールも設定
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # 全てのプロトコル
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_efs_mount_target" "mount_target_a" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = var.subnet_a_id
  security_groups = [ aws_security_group.efs_sg.id ]
}

resource "aws_efs_mount_target" "mount_target_b" {
  file_system_id  = aws_efs_file_system.my_efs.id
  subnet_id       = var.subnet_b_id
  security_groups = [ aws_security_group.efs_sg.id ]
}

resource "aws_efs_access_point" "my_access_point" {
  file_system_id = aws_efs_file_system.my_efs.id

  root_directory {
    path = "/mnt/efs" # or the path you want your Lambda to access
    creation_info {
      owner_gid = 1000
      owner_uid = 1000
      permissions = "0777"
    }
  }
}
