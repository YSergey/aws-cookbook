module "IAM" {
    source = "./modules/IAM"
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

module "ALB" {
    source = "./modules/ALB"
    sysname = local.ALB.sysname

    vpc_id = module.VPC.vpc_id
    subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]
}

module "ECR" {
    source = "./modules/ECR"
    sysname = local.ECR.sysname
}

module "ECS" {
    source = "./modules/ECS" 
    sysname = local.ECS.sysname
    ecs_iam_role = module.IAM.ecs_iam_role_arn

    vpc_id = module.VPC.vpc_id
    subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]

    instance_profile = module.IAM.instance_profile

    alb_sg_id = module.ALB.alb_sg_id
    blue_tg_group_arn = module.ALB.blue_tg_group_arn
}

module "SSH_KEYGEN" {
    source = "./modules/SSH_KEYGEN"
}