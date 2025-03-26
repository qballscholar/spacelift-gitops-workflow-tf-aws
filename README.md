# Spacelift GitOps Workflow with AWS EKS + Fargate

---

## AWS EKS Infrastructure with Terraform

This repository contains Terraform templates designed to provision an Amazon Elastic Kubernetes Service (EKS) infrastructure on AWS. The modular architecture allows for easy deployment and management of scalable, secure Kubernetes clusters.

## Repository Structure

The repository is organized in a modular fashion:

- **Root directory**: Contains the main Terraform configuration files and variables
- **vpc/**: Module for creating and configuring the Virtual Private Cloud infrastructure
- **eks/**: Module for provisioning and configuring the EKS cluster and node groups

## Infrastructure Components

This Terraform project provisions the following AWS resources:

- **Virtual Private Cloud (VPC)**: Isolated network environment with public and private subnets across multiple Availability Zones.
- **IAM Roles and Policies**: Necessary permissions for EKS service and worker nodes.
- **Security Groups**: Control inbound and outbound traffic to the EKS cluster.
- **EKS Cluster**: Managed Kubernetes control plane with AWS-optimized configurations.
- **Worker Node Groups**: Auto-scaling EC2 instances to run your containerized workloads.
- **Networking Components**: Route tables, internet gateways, and NAT gateways.

The infrastructure is designed following AWS best practices for high availability, security, and scalability.

## Supported Applications

This EKS infrastructure supports a wide range of containerized applications:

- **Microservices Architectures**: Deploy complex, distributed applications with service discovery and load balancing.
- **High-Availability Web Applications**: Run web services with automatic scaling and resilience across multiple Availability Zones.
- **CI/CD Pipelines**: Enable automated building, testing, and deployment workflows.
- **Machine Learning Workloads**: Support for TensorFlow, PyTorch, and other ML frameworks with GPU capabilities.
- **Batch Processing Jobs**: Execute resource-intensive computational tasks efficiently.
- **Serverless Applications**: Can be configured to work with AWS Fargate for serverless container execution.
- **Hybrid/Multi-Cloud Deployments**: Compatible with EKS Anywhere for consistent operation across environments.

## Who Is This Project For?

This project is ideal for:

- **Cloud Engineers/Architects**: Professionals looking to implement infrastructure as code for Kubernetes deployments.
- **DevOps Teams**: Teams seeking to automate the provisioning and management of Kubernetes infrastructure.
- **Platform Engineers**: Those building reliable platforms for application teams to deploy workloads.
- **Organizations Migrating to Kubernetes**: Companies looking to adopt container orchestration with proper AWS integration.
- **Development Teams**: Groups that need a consistent, reproducible Kubernetes environment for application deployment.

## Prerequisites

- AWS account with appropriate permissions
- Terraform (version 1.0+) installed
- AWS CLI configured with appropriate credentials
- Basic understanding of Kubernetes and AWS services

## Getting Started

1. Clone this repository:

```bash
git clone https://github.com/qballscholar/spacelift-gitops-workflow.git
```

2. Navigate to the repository directory:

```bash
cd spacelift-gitops-workflow
```

3. Initialize Terraform:

```bash
terraform init
```

4. Review and modify the variables in the root directory to match your requirements
5. Plan the deployment:

```bash
terraform plan
```

6. Apply the configuration:

```bash
terraform apply
```

7. After deployment, configure kubectl using the output:

```bash
aws eks update-kubeconfig --name <cluster-name> --region <region>
```

## Cost Considerations

AWS EKS clusters cost \$0.10 per hour, plus the cost of EC2 instances for worker nodes. Be sure to monitor your usage and clean up resources when no longer needed to avoid unnecessary charges.
