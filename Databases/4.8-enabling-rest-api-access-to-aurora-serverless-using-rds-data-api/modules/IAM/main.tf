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

resource "aws_iam_policy" "db_policy" {
  name        = "${var.sysname}-db-policy"
  description = "DB policy"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Action": [
        "rds-data:BatchExecutionStatement",
        "rds-data:BeginTransaction",
        "rds-data:CommitTransaction",
        "rds-data:ExecuteStatement",
        "rds-data:RollbackTransaction",
      ],
      "Resource": "*",
      "Effect": "Allow"
    }, 
    {
      "Action" : [
        "secrersmanager:GetSecretValue",
        "secretmanager:DescribeSecret",
      ],
      "Resource": "*",
      "Effect": "Allow"
    }]
  })
}


# IAMロールにマネージドポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAMロールにマネージドポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "db_policy" {
  role = aws_iam_role.instance.name 
  policy_arn = aws_iam_policy.db_policy.arn
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