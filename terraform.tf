terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # NOTE: Do not include backend configuration here
  # Backend is managed by Spacelift.io
}

provider "aws" {
  region = "us-east-1"
}

# Call modules directly from root
module "vpc" {
  source = "./infra/vpc"
}

module "eks" {
  source = "./infra/eks"
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
}