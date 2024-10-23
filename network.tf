resource "aws_security_group" "telemetry_sg" {
  name        = "${var.task_name}-sg"
  description = "Security group for telemetry services"
  vpc_id      = "vpc-099725eae4c0e2586"  # Replace with your VPC ID

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

  // Optionally add egress rules if needed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  // Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
