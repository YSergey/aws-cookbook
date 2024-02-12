module "s3" {
  source = "./modules/S3"

  sysname = local.s3.sysname
  bucket_name = local.s3.bucket_name
  object_ownership = local.s3.object_ownership
  acl = local.s3.acl
}