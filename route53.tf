##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This configuration retrieves an existing Route 53 hosted zone 
# and creates an alias record pointing to the Network Load 
# Balancer (NLB) configured for the telemetry services. 
# The alias record allows access to the NLB via a friendly 
# subdomain (e.g., app.f1telemetry.online), enabling users 
# to reach the services routed by the NLB with ease. Health 
# checks are enabled for improved fault tolerance.
##################################################
data "aws_route53_zone" "existing_zone" {
  name = "f1telemetry.online."
}

resource "aws_route53_record" "nlb_alias" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  name     = "app" 
  type     = "A"  # Use "A" for IPv4 addresses

  alias {
    name                   = aws_lb.nlb.dns_name  # Reference the NLB DNS name
    zone_id                = aws_lb.nlb.zone_id    # Reference the NLB Zone ID
    evaluate_target_health = true                   # Optional: Evaluate target health
  }
}
