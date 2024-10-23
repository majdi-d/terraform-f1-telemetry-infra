variable "aws_region" {
  description = "AWS region to deploy the ECS task"
  type        = string
  default     = "us-east-1"
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
