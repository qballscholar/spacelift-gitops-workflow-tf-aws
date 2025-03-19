terraform {
  required_version = "~> 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # Each stack needs its own state file
  backend "s3" {
    bucket = "tf-state-bucket-spacelift"
    key    = "spacelift/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  
  name = "spacelift-eks-vpc"
  cidr = "10.0.0.0/16"
  
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  
  tags = {
    Environment = "dev"
    Terraform   = "true"
    GitOps      = "true"
    ManagedBy   = "spacelift"
  }
  
  # Enhanced tags for EKS integration
  public_subnet_tags = {
    "kubernetes.io/role/elb"                      = "1"
    "kubernetes.io/cluster/spacelift-eks-cluster" = "shared"
  }
  
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"             = "1"
    "kubernetes.io/cluster/spacelift-eks-cluster" = "shared"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "private_subnets" {
  value = module.vpc.private_subnets
  description = "List of IDs of private subnets"
}

output "public_subnets" {
  value = module.vpc.public_subnets
  description = "List of IDs of public subnets"
}
