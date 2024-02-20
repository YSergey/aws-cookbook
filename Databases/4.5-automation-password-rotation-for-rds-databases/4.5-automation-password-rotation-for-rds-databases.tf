provider "aws" {
  region = "us-west-2" # update to your region
}

# Step 1 & 2: Use AWS Secrets Manager to generate a password and change the RDS password to this one
resource "aws_secretsmanager_secret" "rds_password" {
  name = "RDS_DB_Password"
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = "your_new_password_here"
}

# Step 4: Generate rdscreds.json (You'll do this step manually with `sed` as Terraform doesn't inherently support it)

# Step 5 & 6: Download and compress the lambda function
resource "aws_lambda_function" "rds_rotation" {
  filename      = "path_to_compressed_lambda_file.zip"
  function_name = "RDS_Rotation"
  role          = aws_iam_role.lambda_iam_role.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256("path_to_compressed_lambda_file.zip")

  runtime = "python3.x"
  
  vpc_config {
    security_group_ids = [aws_security_group.lambda_sg.id]
    subnet_ids         = ["your_subnet_id_1", "your_subnet_id_2"]
  }
}

# Step 7 & 8: Security Group for Lambda & RDS
resource "aws_security_group" "lambda_sg" {
  name        = "Lambda SG"
  description = "Lambda Security Group"
  vpc_id      = "your_vpc_id"
}

resource "aws_security_group_rule" "allow_lambda_to_rds" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = [aws_security_group.lambda_sg.egress[0].cidr_blocks]
  
  security_group_id = "your_rds_security_group_id"
}

# Step 10: IAM Role for Lambda
resource "aws_iam_role" "lambda_iam_role" {
  name = "lambda_iam_role"
  assume_role_policy = file("assume-role-policy.json") 
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Step 12 & 13: Lambda permission and creating secret
resource "aws_lambda_permission" "allow_secret_manager" {
  statement_id  = "AllowSecretManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_rotation.function_name
  principal     = "secretsmanager.amazonaws.com"
}

resource "aws_secretsmanager_secret_rotation" "rotation" {
  secret_id           = aws_secretsmanager_secret.rds_password.id
  rotation_lambda_arn = aws_lambda_function.rds_rotation.arn
  rotation_rules {
    automatically_after_days = 30
  }
}

# Assuming you manually trigger the rotation or it will be done automatically after 30 days
