resource "aws_dynamodb_table" "example" {
  name           = "${var.sysname}-table"
  hash_key       = "UserID"  // プライマリキーとして UserID を使用

  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "UserID"  // プライマリキーの属性
    type = "S"
  }

}
