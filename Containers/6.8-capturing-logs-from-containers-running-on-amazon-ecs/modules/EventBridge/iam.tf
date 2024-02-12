data "aws_iam_policy_document" "eventbridge_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eventbridge_service_role" {
  name               = "${var.sysname}-eventbridge-service-role"
  assume_role_policy = data.aws_iam_policy_document.eventbridge_policy.json
}

# CloudWatch Logs用IAMポリシー
data "aws_iam_policy_document" "cloudwatch_logs_policy" {
  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "${var.sysname}-eventbridge-cloudwatch-logs-policy"
  description = "ECS tasks to CloudWatch Logs policy"
  policy      = data.aws_iam_policy_document.cloudwatch_logs_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  role       = aws_iam_role.eventbridge_service_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}


# IAM role for EventBridge to ECS task execution
resource "aws_iam_role" "eventbridge_ecs_role" {
  name = "${var.sysname}-eventbridge-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM policy to allow EventBridge to run ECS tasks
resource "aws_iam_policy" "eventbridge_ecs_policy" {
  name        = "${var.sysname}-eventbridge-ecs-policy"
  description = "Allows EventBridge to put logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "ecs:RunTask",
        Resource = var.ecs_task_definition_arn
      }
    ]
  })
}

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "eventbridge_ecs_policy_attach" {
  role       = aws_iam_role.eventbridge_ecs_role.name
  policy_arn = aws_iam_policy.eventbridge_ecs_policy.arn
}