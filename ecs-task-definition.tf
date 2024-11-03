##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration defines an ECS task definition for the F1 Telemetry project. The task uses three containers:
# 1. InfluxDB: Stores telemetry data, with health checks and environment variables configured for initialization.
# 2. Grafana: Visualizes telemetry data, with dependent startup on InfluxDB and a health check.
# 3. FluxDBExporter: Exports telemetry data, dependent on InfluxDB’s health and logs sent to CloudWatch.
# The task runs on Fargate and specifies resource limits for CPU and memory.
##################################################
resource "aws_ecs_task_definition" "telemetry_task" {
  family                  = var.task_name
  task_role_arn          = aws_iam_role.ecs_task_execution_role.arn  # Use the role ARN from IAM
  execution_role_arn     = aws_iam_role.ecs_task_execution_role.arn  # Use the role ARN from IAM
  network_mode            = var.network_mode
  cpu                     = var.cpu
  memory                  = var.memory
  requires_compatibilities = var.requires_compatibilities

  container_definitions = jsonencode([
    {
      name             = "influxdb"
      image            = "influxdb:2"
      cpu              = local.influxdb_cpu
      memory           = local.influxdb_memory
      essential        = true
      portMappings = [
        {
          name          = "influxdb-8086-tcp"
          containerPort = 8086
          hostPort      = 8086
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "DOCKER_INFLUXDB_INIT_RETENTION", value = "1w" },
        { name = "DOCKER_INFLUXDB_INIT_USERNAME", value = "admin" },
        { name = "DOCKER_INFLUXDB_INIT_ADMIN_TOKEN", value = "MyInitialAdminToken0==" },
        { name = "DOCKER_INFLUXDB_INIT_PASSWORD", value = "MyInitialAdminPassword" },
        { name = "DOCKER_INFLUXDB_INIT_MODE", value = "setup" },
        { name = "DOCKER_INFLUXDB_INIT_BUCKET", value = "mybucket" },
        { name = "SNOWFLAKE_OCSP_MODE", value = "INSECURE" },
        { name = "DOCKER_INFLUXDB_INIT_ORG", value = "myorg" },
        { name = "SNOWFLAKE_OCSP_FAIL_OPEN", value = "false" }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8086 || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
      }
    },
    {
      name             = "grafana"
      image            = "grafana/grafana:latest"
      cpu              = local.grafana_cpu
      memory           = local.grafana_memory
      essential        = false
      portMappings = [
        {
          name          = "grafana-3000-tcp"
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "GF_AUTH_ANONYMOUS_ENABLED", value = "true" },
        { name = "GF_DASHBOARDS_MIN_REFRESH_INTERVAL", value = "200ms" },
        { name = "GF_SECURITY_ADMIN_PASSWORD", value = "MyGrafanaAdminPassword" }
      ]
      dependsOn = [   # Correct usage for the ECS task definition context
        {
          containerName = "influxdb"
          condition     = "START"
        }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000 || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
      }
    },
    {
      name             = "fluxdbexporter"
      image            = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/telemetry-repo:latest"
      cpu              = local.fluxdbexporter_cpu
      memory           = local.fluxdbexporter_memory
      essential        = false
      portMappings = [
        {
          containerPort = 20777
          hostPort      = 20777
          protocol      = "udp"
        },
        {
          name          = "fluxdbexporter-http-8080"
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "INFLUXDB_URL", value = "http://127.0.0.1:8086" }
      ]
      dependsOn = [   # Correct usage for the ECS task definition context
        {
          containerName = "influxdb"
          condition     = "HEALTHY"
        }
      ]
    # Add this once the runtime image is able to install cURL, otherwise the health check will fail because cURL is not installed on the service container
    #   healthCheck = {
    #     command     = ["CMD-SHELL", "curl -f http://localhost:8080/health/ || exit 1"]
    #     interval    = 30
    #     timeout     = 5
    #     retries     = 3
    #   }
      logConfiguration = {  # Correct naming for log configuration
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.task_name}-logs"
          "mode"                  = "non-blocking"
          "awslogs-create-group"  = "true"
          "max-buffer-size"       = "25m"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}
