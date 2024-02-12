data "aws_caller_identity" "current" {}

locals {
  IAM = {
    sysname = "automating-csv-import-into-dynamodb"
  }
}

locals {
  Lambda = {
    sysname = "automating-csv-import-into-dynamodb"
    file_name = "modules/Lambda/lambda_function.zip"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
  }
}
