##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration defines an ECS cluster resource in AWS. The cluster's name is set using a variable, 
# allowing for flexibility in naming. The commented-out section also provides a reference for an existing ECS cluster if needed.
##################################################
resource "aws_ecs_cluster" "telemetry_cluster" {
  name = var.cluster_name
}
