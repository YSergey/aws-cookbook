# # CloudTrail の設定
# resource "aws_cloudtrail" "example" {
#   name                          = "${var.sysname}-cloudtrail"
#   s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
#   include_global_service_events = true
#   is_multi_region_trail         = true
#   enable_logging                = true

#   event_selector {
#     read_write_type           = "WriteOnly"
#     include_management_events = true
#     data_resource {
#       type   = "AWS::S3::Object"
#       values = ["arn:aws:s3:::${var.target_bucket_name}/"]
#     }
#   }
# }

# # CloudTrail 用の S3 バケット
# resource "aws_s3_bucket" "cloudtrail_logs" {
#   bucket = "${var.sysname}-cloudtrail-logs"
# }

# EventBridge rule to monitor S3 bucket for uploads via CloudTrail
# resource "aws_cloudwatch_event_rule" "s3_upload_rule" {
#   name        = "${var.sysname}-s3-upload-rule"
#   description = "Triggers on file upload to S3 bucket"

#   event_pattern = jsonencode({
#     source      = ["aws.s3"]
#     detail-type = ["AWS API Call via CloudTrail"]
#     detail      = {
#       eventSource = ["s3.amazonaws.com"]
#       eventName   = ["PutObject"]
#       requestParameters = {
#         bucketName = [var.target_bucket_name]
#       }
#     }
#   })
# }

# EventBridge rule target to trigger ECS task
# resource "aws_cloudwatch_event_target" "s3_upload_target" {
#   rule      = aws_cloudwatch_event_rule.s3_upload_rule.name
#   arn       = var.ecs_cluster_arn
#   role_arn  = var.eventbridge_ecs_role_arn

#   ecs_target {
#     task_count          = 1
#     task_definition_arn = var.ecs_task_definition_arn
#     launch_type         = "FARGATE"

#     network_configuration {
#       subnets         = var.subnet_ids
#       security_groups = [ var.ecs_sg_id_group ]
#       assign_public_ip = true
#     }
#   }
# }

# EventBridge rule target to trigger Lambda function
resource "aws_cloudwatch_event_rule" "s3_upload_rule" {
  name        = "${var.sysname}-s3-upload-rule"
  description = "Triggers on file upload to S3 bucket"

  event_pattern = jsonencode({
    "detail-type" : ["Object Created"],
    "source" : ["aws.s3"],
    "detail" : {
      "bucket" : {
        "name" : [var.target_bucket_name]
      },
      # "object" : {
      #   "key" : [{
      #     "prefix" : "input-file/"
      #   }]
      # }
    }
  })
}

resource "aws_cloudwatch_event_target" "s3_upload_lambda_target" {
  rule = aws_cloudwatch_event_rule.s3_upload_rule.name
  arn  = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.s3_upload_rule.arn
}