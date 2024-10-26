# F1 Telemetry with AWS

## Overview

The **F1 Telemetry with AWS** project aims to automate the collection and reporting of telemetry data using various AWS services. This project leverages AWS resources such as Elastic Container Service (ECS), Elastic Load Balancing, Route 53, and VPCs to create a scalable and resilient architecture for handling telemetry data efficiently.

## Table of Contents

- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Resources](#resources)
- [Deployment](#deployment)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Project Structure
f1-telemetry/ │ ├── modules/ │ ├── vpc/ │ │ └── main.tf │ ├── ecs/ │ │ └── main.tf │ ├── nlb/ │ │ └── main.tf │ └── route53/ │ └── main.tf │ ├── outputs.tf ├── variables.tf ├── main.tf └── README.md

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- An AWS account with appropriate permissions
- AWS CLI configured with your credentials

### Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/f1-telemetry.git
    cd f1-telemetry
    ```

2. Initialize Terraform:
    ```bash
    terraform init
    ```

3. Review and customize `variables.tf` to match your environment:
    - Update the AWS region and other variables as needed.

## Resources

The project deploys the following AWS resources:

- **VPC**: A dedicated Virtual Private Cloud to host all services.
- **ECS**: Elastic Container Service for running containerized applications.
- **NLB**: Network Load Balancer for distributing incoming traffic.
- **Route 53**: DNS management for routing traffic to the NLB.

## Deployment

To deploy the infrastructure, run the following command:

```bash
terraform apply
