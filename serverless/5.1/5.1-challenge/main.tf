provider "aws" {
  region = var.region
}

locals {
  azs = ["us-west-2a", "us-west-2b"]
}

module "vpc" {
  source = "./modules/vpc"
  azs    = local.azs
}

module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.subnet_ids
  alb_sg         = module.vpc.alb_sg
  lambda_vtg     = module.lambda.lambda_tg_arn 
  lambda_function_name = module.lambda.function_name
  fargate_arn    = module.ecs.fargate_arn
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  alb_security_group = module.vpc.alb_sg
  ecs_security_group = module.vpc.ecs_sg
}

module "lambda" {
  source = "./modules/lambda"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = [module.vpc.alb_sg]
  allow_lb_permission = module.alb.aws_lambda_permission
}
