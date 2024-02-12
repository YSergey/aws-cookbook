resource "aws_dynamodb_table" "my_table" {
  name           = var.table_name
  read_capacity  = 5  # Initial provisioned read capacity
  write_capacity = 5  # Initial provisioned write capacity
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "N"
  }
}

resource "aws_appautoscaling_target" "read_scale_target" {
  max_capacity       = 10  # Maximum read capacity
  min_capacity       = 5   # Minimum read capacity
  resource_id        = "table/${aws_dynamodb_table.my_table.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_target" "write_scale_target" {
  max_capacity       = 10  # Maximum write capacity
  min_capacity       = 5   # Minimum write capacity
  resource_id        = "table/${aws_dynamodb_table.my_table.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_scale_policy" {
  name               = "dynamodb-read-scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.read_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.read_scale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_scale_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value       = 70  # Scale when read utilization is over 70%
    scale_in_cooldown  = 60  # Cooldown 60 seconds after scaling in
    scale_out_cooldown = 60  # Cooldown 60 seconds after scaling out
  }
}

resource "aws_appautoscaling_policy" "write_scale_policy" {
  name               = "dynamodb-write-scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.write_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.write_scale_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_scale_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value       = 70  # Scale when write utilization is over 70%
    scale_in_cooldown  = 60  # Cooldown 60 seconds after scaling in
    scale_out_cooldown = 60  # Cooldown 60 seconds after scaling out
  }
}
