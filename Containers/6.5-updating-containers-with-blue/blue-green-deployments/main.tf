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
    ecs_task_role = module.IAM.ecs_task_role_arn

    vpc_id = module.VPC.vpc_id
    subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]

    alb_sg_id = module.ALB.alb_sg_id
    blue_tg_group_arn = module.ALB.blue_tg_group_arn
}

module "CodeDeploy" {
    source = "./modules/CodeDeploy" 
    sysname = local.CodeDeploy.sysname

    codedeploy_iam_arn = module.IAM.codedeploy_ima_arn

    alb_listener_arn = module.ALB.alb_listener_arn
    alb_tg_group_blue_name = module.ALB.blue_tg_group_name
    alb_tg_group_green_name = module.ALB.green_tg_group_name

    cluster_name = module.ECS.cluster_name
    service_name = module.ECS.service_name
}

module "S3" {
    source = "./modules/S3" 
    sysname = local.S3.sysname
    appspec = module.ECS.appspec
}

module "SSH_KEYGEN" {
    source = "./modules/SSH_KEYGEN"
}