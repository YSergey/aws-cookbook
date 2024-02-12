resource "aws_lambda_function" "example_lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = var.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime

  depends_on = [
    var.lambda_execution_role_arn
  ]

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

   file_system_config {
    arn            = var.efs_accesspoint_arn
    local_mount_path = "/mnt/efs"
  }
}

resource "aws_security_group" "lambda_sg" {
  name   = "lambda_sg"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "lambda_efs_ingress_https" {
  security_group_id = aws_security_group.lambda_sg.id

  type        = "ingress"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]  
}

resource "aws_security_group_rule" "lambda_efs_egress_https" {
  security_group_id = aws_security_group.lambda_sg.id

  type        = "egress"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ] 
}