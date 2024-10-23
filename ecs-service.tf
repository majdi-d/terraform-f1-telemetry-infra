resource "aws_ecs_service" "svc1234" {
  name                              = "svc1234"
  cluster                           = aws_ecs_cluster.telemetry_cluster.id
  task_definition                   = aws_ecs_task_definition.telemetry_task.arn  # Reference to the task definition created earlier
  desired_count                     = 1
  launch_type                       = "FARGATE"

  # Deployment configuration (optional settings)
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent          = 200

  network_configuration {
    subnets          = [aws_subnet.private_subnet1.id]
    security_groups  = [aws_security_group.telemetry_sg.id]
    assign_public_ip = false
  }
# Load balancer configuration for InfluxDB
  load_balancer {
    target_group_arn = aws_lb_target_group.influxdb_tg.arn  # Reference to the InfluxDB target group
    container_name   = "influxdb"  # Replace with the actual container name for InfluxDB
    container_port   = 8086         # Port on which the InfluxDB container listens
  }

  # Load balancer configuration for Grafana
  load_balancer {
    target_group_arn = aws_lb_target_group.grafana_tg.arn  # Reference to the Grafana target group
    container_name   = "grafana"    # Replace with the actual container name for Grafana
    container_port   = 3000          # Port on which the Grafana container listens
  }

  # Load balancer configuration for FluxDBExporter
  load_balancer {
    target_group_arn = aws_lb_target_group.fluxdb_exporter_tg.arn  # Reference to the FluxDBExporter target group
    container_name   = "fluxdbexporter"  # Replace with the actual container name for FluxDBExporter
    container_port   = 20777                # Port on which the FluxDBExporter container listens
  }
  # Optionally specify the platform version
  platform_version = "LATEST"

  # Optionally configure tags (optional)
  tags = {
    Name = "ECS Service svc1234"
  }
  depends_on = [ 
    aws_lb.nlb,
    aws_nat_gateway.nat 
    ]
}