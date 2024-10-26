##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration retrieves the current AWS account ID using the aws_caller_identity data source. 
# It also contains commented-out code that can be used to reference an existing ECS cluster named "f1-telemetry-cluster".
##################################################
# Get the current AWS account ID
data "aws_caller_identity" "current" {}

# data "aws_ecs_cluster" "existing_cluster" {
#   cluster_name = "f1-telemetry-cluster"
# }