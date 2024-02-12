module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
}

module "ECR" {
  source = "./modules/ECR"
  sysname = local.ECR.sysname
}

module "Lambda" {
  source = "./modules/Lambda"

  function_name = local.Lambda.function_name 
  lambda_execution_role_arn = module.IAM.lambda_role_arn
  package_type = local.Lambda.package_type
  image_url = module.ECR.image_uri
}