terraform {
  required_version = "~> 1.5.7"
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
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "dev"
      Terraform   = "true"
      GitOps      = "true"
    }
  }
}

# Call modules directly from root
module "vpc" {
  source = "./infra/vpc"
}

module "eks" {
  source  = "./infra/eks"
  vpc_id  = module.vpc.id
  subnet_ids = module.vpc.private_subnets
}
