resource "aws_ecs_task_definition" "telemetry_task" {
  family                   = var.task_name
  task_role_arn           = var.task_role_arn
  execution_role_arn      = var.execution_role_arn
  network_mode            = var.network_mode
  cpu                     = var.cpu
  memory                  = var.memory
  requires_compatibilities = var.requires_compatibilities

  container_definitions = jsonencode([
    {
      name             = "influxdb"
      image            = "influxdb:2"
      cpu              = 0
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
      healthCheck {
        command     = ["CMD-SHELL", "curl -f http://localhost:8086 || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
      }
    },
    {
      name             = "grafana"
      image            = "grafana/grafana:latest"
      cpu              = 0
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
      depends_on = [
        {
          container_name = "influxdb"
          condition      = "START"
        }
      ]
      healthCheck {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000 || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
      }
    },
    {
      name             = "fluxdbexporter"
      image            = "541962714297.dkr.ecr.us-east-1.amazonaws.com/telemetry-repo:latest"
      cpu              = 0
      essential        = false
      portMappings = [
        {
          containerPort = 20777
          hostPort      = 20777
          protocol      = "udp"
        }
      ]
      environment = [
        { name = "INFLUXDB_URL", value = "http://127.0.0.1:8086" }
      ]
      depends_on = [
        {
          container_name = "influxdb"
          condition      = "HEALTHY"
        }
      ]
      log_configuration {
        log_driver = "awslogs"
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
