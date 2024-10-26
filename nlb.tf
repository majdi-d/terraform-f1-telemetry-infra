##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration defines a Network Load Balancer (NLB) 
# and associated target groups for InfluxDB, Grafana, and FluxDB Exporter services. 
# The NLB is set up with public subnets to route traffic to these services 
# based on specific ports, allowing both TCP and UDP traffic. 
# Health checks are configured for each target group to ensure service availability.
##################################################
resource "aws_lb" "nlb" {
  name               = "${var.task_name}-nlb"
  load_balancer_type = "network"
  security_groups    = [aws_security_group.telemetry_sg.id]
  # Associate NLB with public subnets only
  subnets = [
    aws_subnet.public_subnet1.id,
    aws_subnet.public_subnet2.id
  ]

  enable_deletion_protection = false
}

# InfluxDB target group for port 8086
resource "aws_lb_target_group" "influxdb_tg" {
  name        = "${var.task_name}-influxdb-tg"
  port        = 8086
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"  # ECS tasks running in private subnet with private IPs

  health_check {
    port                = "8086"
    protocol            = "HTTP"
    path                = "/"  # Adjust this path based on your service health check
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Grafana target group for port 3000
resource "aws_lb_target_group" "grafana_tg" {
  name        = "${var.task_name}-grafana-tg"
  port        = 3000
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"  # ECS tasks running in private subnet with private IPs

  health_check {
    port                = "3000"
    protocol            = "HTTP"
    path                = "/"  # Adjust this path for Grafana or the service you're using
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# FluxDBExporter target group for UDP port 20777
resource "aws_lb_target_group" "fluxdb_exporter_tg" {
  name        = "${var.task_name}-fluxdbexporter-tg"
  port        = 20777
  protocol    = "UDP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"  # ECS tasks running in private subnet with private IPs

  health_check {
    port                = "8080"  # Use TCP port 8080 for the health check
    protocol            = "HTTP"  # HTTP-based health check
    path                = "/health"  # Health check endpoint
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listener for InfluxDB (port 8086)
resource "aws_lb_listener" "influxdb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8086
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.influxdb_tg.arn
  }
}

# Listener for Grafana (port 3000)
resource "aws_lb_listener" "grafana_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 3000
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn
  }
}

# Listener for FluxDBExporter (UDP port 20777)
resource "aws_lb_listener" "fluxdb_exporter_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 20777
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fluxdb_exporter_tg.arn
  }
}
