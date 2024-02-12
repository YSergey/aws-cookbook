# ECSの実行ロール
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# ECSの実行ロールポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECSタスク用のIAMロール
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  # このポリシーはECSサービスがEC2インスタンスまたはFargate上でタスクを実行するために必要です
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# タスクロールに追加のポリシーをアタッチする場合は、aws_iam_role_policy_attachmentを使用します
# 例えば、タスクがS3バケットにアクセスする必要がある場合は、以下のように設定します
resource "aws_iam_role_policy_attachment" "ecs_task_s3_access" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # S3読み取り専用アクセスの例
}

# CloudWatch Logs用IAMポリシー
data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "${var.sysname}-ecs-cloudwatch-logs-policy"
  description = "ECS tasks to CloudWatch Logs policy"
  policy      = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

# ECS実行ロールにポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

# CloudWatch Logsグループ
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "${var.sysname}/ecs"
}