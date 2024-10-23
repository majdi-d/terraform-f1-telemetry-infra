##################################################
# Project: Automating ECR Vulnerability Reporting with Amazon EventBridge
# Author: Majdi Dhissi
# Summary: This configuration sets up the required provider for AWS and specifies the region for resources.
#
# The process involves:
# 1. Defining the AWS provider using HashiCorp's Terraform AWS provider, specifying version 5.70.0.
# 2. Configuring the provider to use the 'us-east-1' region for all AWS resources defined in this Terraform configuration.
##################################################


terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}