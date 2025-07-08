# 6. Athenaワークグループの作成
resource "aws_athena_workgroup" "workgroup" {
  name = "awscookbook704-workgroup"

  configuration {
    result_configuration {
      output_location = "s3://${bucket_id}/"
    }
  }
}