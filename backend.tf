##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration defines the backend for storing the Terraform state file in an Amazon S3 bucket. 
# It also enables encryption of the state file and uses a DynamoDB table for state locking and consistency. 
# The state file is stored in the "tf-f1-telemetry-bkend" S3 bucket in the "me-central-1" region.
##################################################
terraform {
  backend "s3" {
    bucket         = "tf-f1-telemetry-bkend"
    key            = "state/terraform.tfstate"
    region         = "me-central-1"
    encrypt        = true
    dynamodb_table = "tf-f1-telemetry-state"
  }
}