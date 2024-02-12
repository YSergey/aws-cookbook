module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
}

module "S3" {
  source = "./modules/S3"
  sysname = local.S3.sysname 

  object_key = local.S3.object_key
  source_path = local.S3.source_path
  lambda_arn = module.Lambda.lambda_arn
}

module "DynamoDB" {
  source = "./modules/DynamoDB"
  sysname = local.DynamoDB.sysname
}

module "Lambda" {
  source = "./modules/Lambda"

  function_name = local.Lambda.function_name 
  lambda_execution_role_arn = module.IAM.lambda_role_arn
  s3_arn = module.S3.s3_arn
  bucket_name = "${local.S3.sysname}-bucket"
  table_name = "${local.DynamoDB.sysname}-table"

  handler = local.Lambda.handler
  runtime = local.Lambda.runtime
  file_name = local.Lambda.file_name
}

