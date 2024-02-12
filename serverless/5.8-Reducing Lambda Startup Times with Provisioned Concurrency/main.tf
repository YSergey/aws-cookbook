module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
}

module "Lambda" {
  source = "./modules/Lambda"

  function_name = local.Lambda.function_name 
  lambda_execution_role_arn = module.IAM.lambda_role_arn
  handler = local.Lambda.handler
  runtime = local.Lambda.runtime
  file_name = local.Lambda.file_name
}

