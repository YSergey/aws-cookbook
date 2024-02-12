resource "aws_lambda_function" "example_lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = var.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime

  #環境変数の定義
  environment {
    variables = {
      bucket    = var.bucket_name 
      ECS_CLUSTER_NAME = var.ecs_cluster_name
      ECS_TASK_DEFINITION = var.ecs_task_definition_arn
      ECS_SUBNET_ID = join(",", var.subnet_ids)
      CONTAINER_NAME = var.container_name
    }
  }

  depends_on = [
    var.lambda_execution_role_arn
  ]
}
