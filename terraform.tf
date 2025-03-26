terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.83.0"
    }
  }
}

# NOTE: Do not include backend configuration here
# Backend is managed by Spacelift.io

provider "aws" {
  region = var.region
  default_tags {
    tags = var.tags
  }
}

# Call modules directly from root
module "eks-vpc" {
  source = "./vpc"
}

module "eks" {
  source          = "./eks"
  vpc_id          = module.eks-vpc.vpc_id
  private_subnets = module.eks-vpc.private_subnets
}