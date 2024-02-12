module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
}

module "Lambda" {
  source = "./modules/Lambda"

  lambda_execution_role_arn = module.IAM.lambda_role_arn
  function_name = local.Lambda.function_name
  file_name = local.Lambda.file_name
  handler = local.Lambda.handler
  runtime = local.Lambda.runtime

}

module "EventBridge" {
  source = "./modules/EventBridge"

  lambda_arn = module.Lambda.lambda_arn
  function_name = local.EventBridge.function_name
}
