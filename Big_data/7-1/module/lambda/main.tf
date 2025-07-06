resource "aws_lambda_function" "kinesis_processor" {
  function_name = "KinesisProcessor"
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repo.repository_url}:latest"
}

resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn  = var.kinesis_event_source_arn
  function_name     = aws_lambda_function.kinesis_processor.arn
  starting_position = "LATEST"
  enabled           = true
}