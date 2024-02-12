module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
}

module "Lambda" {
  source = "./modules/Lambda"

  lambda_execution_role_arn = module.IAM.lambda_role_arn
  function_name = local.Lambda.function_name
  handler = local.Lambda.handler
  runtime = local.Lambda.runtime

  signed_code_bucket =local.S3.signed_code_bucket
  path_key = module.S3.source_code_s3_key
  object_key = local.S3.object_key

  lambda_code_signing_config_arn = module.Signed.signing_config_arn
}

module "S3" {
  source = "./modules/S3"
  sysname = local.S3.sysname

  source_code_bucket = local.S3.source_code_bucket
  source_path = local.S3.source_path

  signed_code_bucket = local.S3.signed_code_bucket
  object_key = local.S3.object_key
}

module "Signed" {
  source = "./modules/Signer"
  sysname = local.Signed.sysname

  source_code_bucket = local.S3.source_code_bucket
  signed_code_bucket = local.S3.signed_code_bucket
  path_key = module.S3.source_code_s3_key
  source_version_id = module.S3.source_code_object_version_id
  object_key = local.S3.object_key
}