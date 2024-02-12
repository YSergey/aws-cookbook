
module "s3" {
  source = "./modules/S3"

  sysname = local.s3.sysname
  bucket_name = local.s3.bucket_name
  object_ownership = local.s3.object_ownership
  acl = local.s3.acl

  my_kms_key_id = module.KMS.kms_key_id
}

module "KMS" {
  source = "./modules/KMS"

  my_kms_key_alias = local.KMS.my_kms_key_alias
}

