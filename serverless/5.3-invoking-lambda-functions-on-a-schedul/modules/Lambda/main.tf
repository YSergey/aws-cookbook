# Lambda function
resource "aws_lambda_function" "example_lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime
  timeout = 30

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [ aws_security_group.lambda_sg.id ]
  }

  environment {
    variables = {
      DB_HOST = var.DB_HOST
      USER_NAME     = var.USER_NAME          
    }
  }
}

#Lambdaのセキュリティグループ
resource "aws_security_group" "lambda_sg" {
  name        = "${var.sysname}-lambda-sg"
  description = "Allow outbound traffic to RDS-proxy"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}