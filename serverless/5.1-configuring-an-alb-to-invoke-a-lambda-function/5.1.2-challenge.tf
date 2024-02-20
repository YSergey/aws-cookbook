provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Public Subnets
locals {
  azs = ["us-west-2a", "us-west-2b"]
}

resource "aws_subnet" "main" {
  count                  = length(local.azs)
  cidr_block             = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  vpc_id                 = aws_vpc.main.id
  availability_zone      = local.azs[count.index]
  map_public_ip_on_launch = true
}

# Create an IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Create Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  filename      = "path/to/lambda_function_payload.zip"
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "my_api"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_method.http_method
  
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "function"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Add permission for API Gateway to invoke Lambda
resource "aws_lambda_permission" "invoke_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

# Deploy API
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [aws_api_gateway_integration.integration]
  
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}

# Create ALB (You can keep the previous ALB configuration)

# Listener Rule for API Gateway
resource "aws_lb_listener_rule" "api_gateway_listener" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 99

  action {
    type = "redirect"
    redirect_action {
      port        = "80"
      protocol    = "HTTP"
      prefix      = "/function"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

# Note: Your existing ALB and Listener Rule for Lambda can stay the same
