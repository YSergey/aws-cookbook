resource "aws_lambda_function" "transform" {
  function_name = "firehose-transform"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.handler"
  runtime       = "python3.8"
  filename      = "lambda_function.zip"
}