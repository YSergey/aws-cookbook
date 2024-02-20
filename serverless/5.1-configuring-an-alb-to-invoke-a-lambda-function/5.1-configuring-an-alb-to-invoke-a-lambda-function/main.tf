

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

  vpc_id = module.VPC.vpc_id
  subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]

  function_name = local.Lambda.function_name
  file_name = local.Lambda.file_name
  handler = local.Lambda.handler
  runtime = local.Lambda.runtime

  security_group_ids = [ module.ALB.alb_sg_id ]
}


module "ALB" {
  source = "./modules/ALB"

  load_balancer_type = local.ALB.load_balancer_type

  vpc_id = module.VPC.vpc_id
  subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]

  lambda_tg_arn =  module.Lambda.lambda_tg_arn
  lambda_function_name = local.Lambda.function_name
}