data "aws_caller_identity" "current" {}

locals {
    s3 = {
        sysname = "using-amazon-s3-bucket-keys-with-KMS-to-encrypt-objects"
        bucket_name = "my-unique-bucket-name-for-aws-cookbook-3.6"
        object_ownership = "BucketOwnerPreferred"
        acl = "private"
    }
}

locals {
  KMS = {
    my_kms_key_alias = "alias/my-s3-bucket-key"
  }
}
