# No backend configuration - Spacelift manages state
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"
  
  cluster_name    = "spacelift-eks-cluster"
  cluster_version = "1.28"

  # Use AWS-managed key for EKS
  create_kms_key = false

   # Use AWS-managed encryption
  cluster_encryption_config = {
    provider_key_arn = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/aws/eks"
    resources        = ["secrets"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  
  # IAM role configuration
  create_iam_role = true
  iam_role_name   = "spacelift-eks-cluster-role"
  iam_role_use_name_prefix = false
  iam_role_description = "EKS cluster role for Spacelift"
  iam_role_additional_policies = {
    additional = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  }

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

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster will be created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster"
}
