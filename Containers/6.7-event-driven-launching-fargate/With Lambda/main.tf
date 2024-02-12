module "IAM" {
    source = "./modules/IAM"

    cluster_name = module.ECS.cluster_name
    service_name = module.ECS.service_name
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

    lambda_iam_arn = module.IAM.lambda_iam_arn
    lambda_function_arn = module.Lambda.lambda_arn
    function_name = local.Lambda.function_name

}

module "Lambda" {
    source = "./modules/Lambda" 

    function_name = local.Lambda.function_name 
    lambda_execution_role_arn = module.IAM.lambda_iam_role_arn
    handler = local.Lambda.handler
    runtime = local.Lambda.runtime
    file_name = local.Lambda.file_name

    event_rule_arn = module.EventBridge.event_rule_arn

    bucket_name = "${local.S3.sysname}-s3-target"
    bucket_arn = module.S3.bucket_arn

    subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ] 
    ecs_cluster_name = module.ECS.cluster_name
    ecs_task_definition_arn = module.ECS.ecs_task_definition_arn
    container_name = local.ECR.container_name
}

module "SSH_KEYGEN" {
    source = "./modules/SSH_KEYGEN"
}