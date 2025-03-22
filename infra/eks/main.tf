# No backend configuration - Spacelift manages state
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"
  
  cluster_name    = "spacelift-eks-cluster"
  cluster_version = "1.24"
  
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
  }
  
  eks_managed_node_groups = {
    main = {
      min_size     = 2
      max_size     = 4
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
  description = "EKS Cluster API Endpoint"
}

output "cluster_name" {
  value = module.eks.cluster_name
  description = "EKS Cluster Name"
  }

# Define variables for VPC and subnet IDs
variable "vpc_id" {
  description = "VPC ID from VPC stack"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs from VPC stack"
  type        = list(string)
}
