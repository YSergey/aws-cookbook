# 2. Create a KMS customer-managed key
resource "aws_kms_key" "my_kms_key" {
  description             = "KMS key for S3 bucket encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 10
}

# 3. Create an alias for the KMS key
resource "aws_kms_alias" "my_kms_key_alias" {
  name          = var.my_kms_key_alias
  target_key_id = aws_kms_key.my_kms_key.key_id
}
