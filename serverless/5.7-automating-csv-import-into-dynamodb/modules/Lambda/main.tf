resource "aws_lambda_function" "example_lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = var.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime

  #環境変数の定義
  environment {
    variables = {
      bucket    = var.bucket_name # ここに実際のバケット名を入れてください
      tableName = var.table_name     # またはその他の環境変数
    }
  }

  depends_on = [
    var.lambda_execution_role_arn
  ]
}

#s_lambda_permissionリソースは、特定のサービス（この場合はS3）から
#Lambda関数を直接呼び出すためのアクセス許可を設定するもの
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.example_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_arn
}
