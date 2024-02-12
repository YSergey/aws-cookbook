resource "aws_lambda_function" "example_lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = var.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime
  publish       = true  # Publish a new version

  environment {
    variables = {
      hostname = var.redis_host
    }
  }

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  depends_on = [
    var.lambda_execution_role_arn
  ]
}

resource "aws_security_group" "lambda_sg" {
  name        = "${var.sysname}_lambda_sg"
  description = "Allow lambda to access ElasticCache"
  vpc_id      = var.vpc_id
}


# Egress rule to allow Lambda to connect to Elasticache Redis
resource "aws_security_group_rule" "lambda_to_redis" {
  type              = "egress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_sg.id
  cidr_blocks       = [ var.subnet_a_cidr, var.subnet_b_cidr ]  # ElastiCache SubnetのCIDRを指定
}
