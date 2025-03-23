terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      }
      kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

  # NOTE: Do not include backend configuration here
  # Backend is managed by Spacelift.io

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
      GitOps      = "true"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# Call modules directly from root
module "vpc" {
  source = "./infra/vpc"
}

module "eks" {
  source     = "./infra/eks"
  vpc_id     = module.vpc.vpc_id  # Changed from module.vpc.id
  subnet_ids = module.vpc.private_subnets
}
