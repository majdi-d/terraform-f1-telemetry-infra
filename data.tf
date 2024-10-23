# Get the current AWS account ID
data "aws_caller_identity" "current" {}

# data "aws_ecs_cluster" "existing_cluster" {
#   cluster_name = "f1-telemetry-cluster"  # Replace with your actual cluster name
# }