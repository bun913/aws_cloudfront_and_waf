resource "aws_ecs_cluster" "web" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  depends_on = [
    aws_lb.app
  ]
}

resource "aws_ecs_cluster_capacity_providers" "web" {
  cluster_name = aws_ecs_cluster.web.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "app" {
  family        = "${var.prefix}-task-def"
  task_role_arn = aws_iam_role.ecs_task.arn
  network_mode  = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  execution_role_arn = aws_iam_role.ecs_task_execution.arn
  memory             = "512"
  cpu                = "256"
  container_definitions = jsonencode([
    {
      name      = "color"
      image     = "${var.ecr_base_uri}:v1"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ],
      environment = [
        {
          "name" : "APP_COLOR",
          "value" : "blue"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      # NOTE:複数コンテナの場合DepentsOnなども利用
      # NOTE: volumeが必要な場合はここで設定(nginxとか利用する場合mountpathとか)
    },
  ])

  volume {
    name = "app-storage"
  }

  depends_on = [
    aws_lb.app
  ]
}

resource "aws_ecs_service" "app" {
  name    = "${var.prefix}-service"
  cluster = aws_ecs_cluster.web.id
  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  platform_version                   = "1.4.0"
  task_definition                    = aws_ecs_task_definition.app.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.app_blue.arn
    container_name   = "color"
    container_port   = 8080
  }

  deployment_controller {
    type = "ECS"
  }

  health_check_grace_period_seconds = 60
  network_configuration {
    assign_public_ip = false
    security_groups = [
      aws_security_group.ecs_service.id
    ]
    subnets = var.private_subnets
  }

  # ECS Exec用
  enable_execute_command = true

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      /* task_definition, */
      /* network_configuration, */
      launch_type,
      platform_version,
      capacity_provider_strategy
    ]
  }
}
