##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration creates an IAM role for ECS task execution with the required permissions to assume the role 
# and attach policies for CloudWatch logging. It includes an inline policy to allow ECS tasks to create and manage logs in CloudWatch.
##################################################

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.task_name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

# Inline policy to allow logging to CloudWatch
resource "aws_iam_policy" "ecs_logging_policy" {
  name        = "${var.task_name}-logging-policy"
  description = "Policy to allow ECS tasks to create CloudWatch logs"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_logging_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_logging_policy.arn
  role       = aws_iam_role.ecs_task_execution_role.name
}


output "ecs_task_execution_role_name" {
  value = aws_iam_role.ecs_task_execution_role.name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
