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

locals {
  S3 = {
    sysname = "automating-csv-import-into-dynamodb"
    object_key = "lambda-s3"
    source_path = "modules/S3/sample_data.csv"
  }
}

locals {
  DynamoDB = {
    sysname = "automating-csv-import-into-dynamodb"
  }
}