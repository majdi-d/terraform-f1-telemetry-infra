resource "aws_ecs_cluster" "telemetry_cluster" {
  name = var.cluster_name
}
