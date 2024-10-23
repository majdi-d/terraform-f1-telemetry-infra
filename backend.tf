##################################################
# Author: Majdi Dhissi
# Project: Automating ECR Vulnerability Reporting with Amazon EventBridge
# Description: 
# This Terraform configuration defines the backend for storing the Terraform state file in an Amazon S3 bucket. 
# It also enables encryption of the state file and uses a DynamoDB table for state locking and consistency. 
# The state file is stored in the "tf-ecr-scan" S3 bucket in the "us-east-1" region.
##################################################
terraform {
  backend "s3" {
    bucket         = "tf-f1-telemetry"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf-f1-telemetry-state"
  }
}