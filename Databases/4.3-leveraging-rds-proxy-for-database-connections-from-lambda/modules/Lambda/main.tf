

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

# IAM policy to allow the Lambda function to access the RDS database
resource "aws_iam_policy" "lambda_rds_policy" {
  name = "lambda_rds_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds-db:connect",
          # Add additional actions as needed
        ],
        Resource = "arn:aws:rds:region:account-id:db:db-instance-name",
        Effect = "Allow",
      },
    ],
  })
}

# Attach the IAM policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_rds_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_rds_policy.arn
}

# Lambda function
resource "aws_lambda_function" "example_lambda" {
  filename         = "path/to/your/lambda/function.zip"  # update this
  function_name    = "example_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"  # update handler
  source_code_hash = filebase64sha256("path/to/your/lambda/function.zip")  # update this
  runtime          = "python3.8"  # update this based on your lambda

  vpc_config {
    subnet_ids         = data.aws_subnet_ids.default.ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DB_ENDPOINT = "your-rds-endpoint"  # Update this
      DB_USER     = "your-db-user"       # Update this
      DB_PASSWORD = "your-db-password"   # Update this
      DB_NAME     = "your-db-name"       # Update this
    }
  }
}

# Security group for the Lambda function
resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Allow outbound traffic to RDS"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "lambda_to_rds" {
  type        = "ingress"
  from_port   = 3306  # Default MySQL port, change if different
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]  # Update to a more restricted CIDR for production

  security_group_id = "id-of-your-rds-instance-security-group"  # Update this
}
