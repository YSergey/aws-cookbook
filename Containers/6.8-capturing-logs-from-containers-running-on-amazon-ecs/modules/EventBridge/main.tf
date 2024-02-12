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

# EventBridge Rule for S3 Bucket Upload
resource "aws_cloudwatch_event_rule" "s3_upload_rule" {
  name        = "${var.sysname}-s3-upload-rule"
  description = "Trigger for S3 bucket uploads"

  event_pattern = jsonencode({
    source     = ["aws.s3"],
    detail     = {
      eventName = ["PutObject"],
      requestParameters = {
        bucketName = [var.target_bucket_name]
      }
    }
  })
}

# EventBridge Rule Target to Trigger ECS Task
resource "aws_cloudwatch_event_target" "fargate_target" {
  rule = aws_cloudwatch_event_rule.s3_upload_rule.name
  arn  = var.ecs_cluster_arn

  role_arn = aws_iam_role.eventbridge_ecs_role.arn # EventBridgeがECSタスクを起動するためのIAMロール


  ecs_target {
    task_count          = 1
    task_definition_arn = var.ecs_task_definition_arn
    launch_type         = "FARGATE"

    network_configuration {
      subnets         = var.subnet_ids
      security_groups = [ var.ecs_sg_id ]
      assign_public_ip = true
    }
  }
}

resource "aws_cloudwatch_event_target" "s3_upload_target" {
  rule      = aws_cloudwatch_event_rule.s3_upload_rule.name
  arn       = var.ecs_cluster_arn
  role_arn  = aws_iam_role.eventbridge_ecs_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = var.ecs_task_definition_arn
    launch_type         = "FARGATE"

    network_configuration {
      subnets         = var.subnet_ids
      security_groups = [ var.ecs_sg_id ]
      assign_public_ip = true
    }
  }
  input = jsonencode({
    containerOverrides = [
      {
        name = var.container_name
        environment = [
          {
            name  = "S3_BUCKET"
            value = "$.detail.requestParameters.bucketName"
          },
          {
            name  = "S3_KEY"
            value = "$.detail.requestParameters.key"
          }
        ]
      }
    ]
  })
}

# CloudWatch Logsグループ
resource "aws_cloudwatch_log_group" "eventbridge_log_group" {
  name = "${var.sysname}/eventbridge"
}