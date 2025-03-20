terraform {
  required_version = "~> 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # No backend configuration - Spacelift manages state
}

provider "aws" {
  region = "us-east-1"
}

# When using Spacelift state management, reference remote state from another stack with:
data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    hostname = "spacelift.io"
    organization = "ralphquick" # Replace with your account name
    workspaces = {
      name = "vpc" # The name of your VPC stack in Spacelift
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"
  
  cluster_name    = "spacelift-eks-cluster"
  cluster_version = "1.24"
  
  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets
  
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
  }
  
  eks_managed_node_groups = {
    main = {
      min_size     = 2
      max_size     = 3
      desired_size = 2
      
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
    GitOps      = "true"
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}
