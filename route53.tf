# Retrieve the existing Route 53 hosted zone
data "aws_route53_zone" "existing_zone" {
  name = "f1telemetry.online."
}

# Create an alias record in Route 53 for the NLB
resource "aws_route53_record" "nlb_alias" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  name     = "app"  # Change this to the desired alias name (e.g., "api.f1telemetry.online")
  type     = "A"  # Use "A" for IPv4 addresses

  alias {
    name                   = aws_lb.nlb.dns_name  # Reference the NLB DNS name
    zone_id                = aws_lb.nlb.zone_id    # Reference the NLB Zone ID
    evaluate_target_health = true                   # Optional: Evaluate target health
  }
}
