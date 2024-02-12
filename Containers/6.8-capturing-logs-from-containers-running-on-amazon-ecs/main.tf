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

    vpc_id = module.VPC.vpc_id
    subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]

    alb_sg_id = module.ALB.alb_sg_id
    blue_tg_group_arn = module.ALB.blue_tg_group_arn

    ecr_repository_url = "129972428809.dkr.ecr.us-west-2.amazonaws.com/event-driven-launching-fargate-container-repo:latest"
    container_name = local.ECR.container_name
}

module "S3" {
    source = "./modules/S3" 
    sysname = local.S3.sysname
}

module "EventBridge" {
    source = "./modules/EventBridge"
    sysname = local.EventBridge.sysname

    target_bucket_name = "${local.S3.sysname}-s3-target"

    subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]

    ecs_cluster_arn = module.ECS.cluster_arn
    ecs_task_definition_arn = module.ECS.ecs_task_definition_arn
    ecs_sg_id = module.ECS.ecs_sg_id
    container_name = local.ECR.container_name

}

module "SSH_KEYGEN" {
    source = "./modules/SSH_KEYGEN"
}