# No backend configuration - Spacelift manages state
module "eks-vpc" {
  source = "../vpc"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.34.0"
  
  cluster_name    = var.cluster_name
  cluster_version = var.eks_version
  tags = var.tags

  vpc_id = module.eks-vpc.vpc_id
  
  # IAM role configuration
  # Disable unnecessary policy management 
  create_iam_role          = true
  attach_cluster_encryption_policy = false

  # EKS cluster configuration
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  
 control_plane_subnet_ids = concat(module.eks-vpc.public_subnets, module.eks-vpc.private_subnets)

  create_cluster_security_group = true
  cluster_security_group_description = "Spacelift EKS cluster security group"

  bootstrap_self_managed_addons = true
  
  # Access Configurations
  authentication_mode = "API"
  enable_cluster_creator_admin_permissions = true

  dataplane_wait_duration = "40s"


  # Security Group Defaults
  enable_security_groups_for_pods = true

  # Disabled Defaults
  create_cloudwatch_log_group = false
  create_kms_key = false
  enable_kms_key_rotation = false
  kms_key_enable_default_policy = false
  enable_irsa = false 
  cluster_encryption_config = {}
  enable_auto_mode_custom_tags = false

  # EKS Managed Node Group(s)
  create_node_security_group = true
  node_security_group_enable_recommended_rules = true
  node_security_group_description = "EKS node group security group for Spacelift nodes to communicate with the cluster API Server"

  node_security_group_use_name_prefix = true

  subnet_ids = module.eks-vpc.private_subnets

  eks_managed_node_groups = {
    group1 = {
    name         = "spacelift"
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = ["t3.medium"]
    capacity_type = "SPOT"
    min_size     = 2
    max_size     = 4
    desired_size = 2
    }
  }

  # Fargate Profile
  fargate_profiles = {
    profile1 = {
    selectors = [
        {
        namespace = "kube-system"
    }
    ]
    }
  }
}
