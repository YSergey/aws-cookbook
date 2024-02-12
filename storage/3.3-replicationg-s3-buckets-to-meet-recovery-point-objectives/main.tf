module "s3" {
  source = "./modules/S3"

  sysname = local.s3.sysname
  bucket_name = local.s3.bucket_name
  object_ownership = local.s3.object_ownership
  acl = local.s3.acl
  replication_arn  = module.iam.replication_arn
}

module "iam" {
  source = "./modules/IAM"
  source_bucket_arn = module.s3.source_bucket_arn
  destination_bucket_arn = module.s3.destination_bucket_arn
}