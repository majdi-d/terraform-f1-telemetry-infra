##################################################
# Author: Majdi Dhissi
# Project: F1 Telemetry with AWS
# Description: 
# This Terraform configuration defines a security group for the telemetry services. 
# It allows inbound traffic for specific ports required by the InfluxDB, Grafana, 
# and FluxDB Exporter services, as well as all outbound traffic. 
# The ingress rules permit HTTP and UDP traffic from anywhere, making the services accessible as needed.
##################################################
resource "aws_security_group" "telemetry_sg" {
  name        = "${var.task_name}-sg"
  description = "Security group for telemetry services"
  vpc_id      = aws_vpc.main.id  # Replace with your VPC ID

  // Ingress rules
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow HTTP from anywhere
  }

  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow HTTP from anywhere
  }

  ingress {
    from_port   = 20777
    to_port     = 20777
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow UDP from anywhere
  }
 ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow health check from anywhere
  }
  // Optionally add egress rules if needed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  // Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
