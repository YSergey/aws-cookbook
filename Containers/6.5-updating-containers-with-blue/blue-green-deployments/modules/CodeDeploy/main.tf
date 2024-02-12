resource "aws_codedeploy_app" "ecs_app_blue_green" {
  name     = "${var.sysname}-application-blue-green"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "example" {
  app_name               = aws_codedeploy_app.ecs_app_blue_green.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.sysname}-blue-green-deployment"
  service_role_arn       = var.codedeploy_iam_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [ var.alb_listener_arn ]
      }

      target_group {
        name = var.alb_tg_group_blue_name
      }

      target_group {
        name = var.alb_tg_group_green_name
      }
    }
  }
}