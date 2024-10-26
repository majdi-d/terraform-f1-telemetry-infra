##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This output block provides the DNS name of the 
# Network Load Balancer (NLB) that is configured 
# for the telemetry services. The DNS name can be 
# used to access the services routed by the NLB.
##################################################
output "nlb_dns_name" {
  description = "The DNS name of the Network Load Balancer"
  value       = aws_lb.nlb.dns_name
}