##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This section defines the input variables used in 
# the Terraform configuration for deploying ECS tasks 
# within the specified AWS region. Each variable has 
# a description detailing its purpose and can be customized 
# based on the deployment requirements. Default values 
# are provided where applicable, allowing for flexibility 
# in configuration.
##################################################
variable "aws_region" {
  description = "AWS region to deploy the ECS task"
  type        = string
  default     = "me-central-1"
}

variable "task_name" {
  description = "The name of the ECS task definition"
  type        = string
}

variable "network_mode" {
  description = "The networking mode to use for the task"
  type        = string
  default     = "awsvpc"
}

variable "cpu" {
  description = "The number of CPU units to allocate"
  type        = string
  default     = "2048"
}

variable "memory" {
  description = "The amount of memory (in MiB) to allocate"
  type        = string
  default     = "4096"
}

variable "requires_compatibilities" {
  description = "The launch type compatibility for the task definition"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "task_role_arn" {
  description = "The ARN of the IAM role for the task"
  type        = string
  default     = "my-ecsTaskExecutionRole"  # Optionally set a default value or leave empty to require input
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  default     = "f1-telemetry-cluster"
}

variable "vpc_name" {
  description = "The name of the VPC"
  default     = "telemetry-vpc"
}
