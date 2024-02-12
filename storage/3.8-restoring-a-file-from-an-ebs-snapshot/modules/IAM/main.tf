resource "aws_iam_role" "instance" {
  name               = "${var.sysname}-ssm-instance"
  path               = "/"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# AmazonSSMManagedInstanceCore の情報を取得
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAMロールにマネージドポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "${var.sysname}-EBS"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "custom_policy_to_backup_role" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

# IAM ロールにポリシーを付与
resource "aws_iam_role_policy" "instance" {
  name   = "${var.sysname}-instance"
  role   =  aws_iam_role.instance.id 
  policy = data.aws_iam_policy.ssm_core.policy
}

# 作成した IAM ロールを割り当てた IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "instance" {
  name = "${var.sysname}-instance"
  role = aws_iam_role.instance.name

  depends_on = [ 
    aws_iam_role_policy.instance
  ]
}