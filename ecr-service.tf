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
    subnets          = ["subnet-0fbe345fb806d775f"]
    security_groups  = [aws_security_group.telemetry_sg.id]
    assign_public_ip = true
  }

  # Optionally specify the platform version
  platform_version = "LATEST"

  # Optionally configure tags (optional)
  tags = {
    Name = "ECS Service svc1234"
  }
}