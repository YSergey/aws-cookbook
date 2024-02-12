module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
}

module "VPC" {
  source = "./modules/VPC" 
  sysname = local.VPC.sysname
  vpc_cidr = local.VPC.vpc_cidr
  subnet_a_cidr = local.VPC.subnet_a_cidr
  subnet_b_cidr = local.VPC.subnet_b_cidr
  az_a = local.VPC.subnet_a_az
  az_b = local.VPC.subnet_b_az
}

module "Lambda" {
  source = "./modules/Lambda"
  sysname = local.Lambda.sysname

  function_name = local.Lambda.function_name 
  lambda_execution_role_arn = module.IAM.lambda_role_arn
  handler = local.Lambda.handler
  runtime = local.Lambda.runtime
  file_name = local.Lambda.file_name

  vpc_id = module.VPC.vpc_id
  subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]
  subnet_a_cidr = module.VPC.subnet_a_cidr
  subnet_b_cidr = module.VPC.subnet_b_cidr
  
  redis_host = module.ElasticCache.redis_host
  redis_sg_id = module.ElasticCache.redis_sg_id
}

module "ElasticCache" {
  source = "./modules/ElasticCache"
  sysname = local.ElasticCache.sysname

  vpc_id = module.VPC.vpc_id
  subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]
  lambda_sg_id = module.Lambda.lambda_sg_id
}