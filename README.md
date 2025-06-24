# Spacelift GitOps Workflow with AWS EKS + Fargate

## Complete Infrastructure as Code Solution with Automated CI/CD Pipeline

This repository provides a production-ready Terraform infrastructure template for deploying Amazon Elastic Kubernetes Service (EKS) clusters with AWS Fargate support, fully integrated with Spacelift.io for GitOps automation. The project demonstrates modern cloud engineering practices by combining Infrastructure as Code (IaC) with continuous deployment workflows.

## **What This Project Is**

This is a comprehensive Terraform-based infrastructure solution that provisions a complete AWS EKS environment with Fargate capabilities. The project showcases how to implement GitOps principles using Spacelift.io as the automation platform, enabling teams to deploy, manage, and scale Kubernetes infrastructure through code commits and pull requests.

## **Purpose and Use Cases**

**Primary Purpose**: Enable development teams to rapidly deploy and manage scalable Kubernetes infrastructure on AWS while maintaining security, compliance, and operational excellence through automated workflows.

**Key Use Cases**:

- **Microservices Deployment**: Support containerized applications with automatic scaling and service discovery
- **CI/CD Pipeline Infrastructure**: Provide the foundation for automated build, test, and deployment workflows
- **Development Environment Provisioning**: Create consistent, reproducible environments for development teams
- **Production Workload Hosting**: Run mission-critical applications with high availability across multiple Availability Zones
- **Serverless Container Execution**: Leverage AWS Fargate for serverless Kubernetes workloads without managing EC2 instances


## **Architecture Overview**

The infrastructure follows a modular design pattern with these core components:

**Networking Layer** (`vpc/` module):

- Virtual Private Cloud with public and private subnets
- Multi-AZ deployment for high availability
- NAT gateways and internet gateways for connectivity
- Security groups with least-privilege access

**Compute Layer** (`eks/` module):

- Managed EKS control plane with AWS-optimized configurations
- Fargate profiles for serverless container execution[^1]
- Auto-scaling node groups for traditional EC2-based workloads
- IAM roles and policies following AWS security best practices


## **Spacelift GitOps Integration**

This project is specifically designed to work with Spacelift.io for complete automation[^2]. The GitOps workflow provides:

**Automated Infrastructure Deployment**:

- Trigger deployments through Git commits and pull requests
- Automated Terraform planning and execution
- Policy enforcement using Open Policy Agent (OPA)
- Drift detection and remediation

**Security and Compliance**:

- Role-based access control for infrastructure changes
- Approval workflows for production deployments
- Audit trails for all infrastructure modifications
- Integration with AWS IAM for secure cloud access


## **Complete Automated Pipeline Setup**

### **Step 1: Repository Preparation**

```bash
# Clone the repository
git clone https://github.com/qballscholar/spacelift-gitops-workflow.git
cd spacelift-gitops-workflow

# Ensure your Terraform modules are properly structured
# Root directory: main.tf, variables.tf, outputs.tf
# vpc/: VPC module with networking components
# eks/: EKS cluster and Fargate profile configurations
```


### **Step 2: Spacelift Stack Configuration**

**Create Primary Infrastructure Stack**:

1. Connect your Git repository to Spacelift
2. Configure the stack to use the root directory as the working directory
3. Enable administrative permissions for AWS resource provisioning
4. Set up AWS integration using Spacelift's native cloud integrations

**Environment Variables Configuration**:

```bash
# Required Terraform variables
TF_VAR_region=us-west-2
TF_VAR_cluster_name=my-eks-cluster
TF_VAR_kubernetes_version=1.27
TF_VAR_vpc_cidr_block=10.0.0.0/16

# Spacelift AWS integration
SPACELIFT_AWS_INTEGRATION_ID=your-integration-id
```


### **Step 3: Fargate Profile Integration**

The project includes support for AWS Fargate profiles using the Cloud Posse Terraform module[^1]. Configure Fargate profiles for serverless container execution:

```hcl
module "eks_fargate_profile" {
  source = "cloudposse/eks-fargate-profile/aws"
  version = "1.0.0"

  subnet_ids = module.subnets.private_subnet_ids
  cluster_name = module.eks_cluster.eks_cluster_id
  kubernetes_namespace = "default"
  kubernetes_labels = {
    "app.kubernetes.io/instance" = "fargate"
  }

  context = module.this.context
}
```


### **Step 4: Policy as Code Implementation**

Implement security policies using Spacelift's OPA integration[^3]:

```rego
# Example policy to enforce resource tagging
package spacelift

deny[sprintf("Resource %s must have required tags", [address])] {
  resource := input.terraform.resource_changes[_]
  resource.type == "aws_eks_cluster"
  address := resource.address
  
  required_tags := ["Environment", "Project", "Owner"]
  existing_tags := object.get(resource.change.after, "tags", {})
  
  required_tag := required_tags[_]
  not existing_tags[required_tag]
}
```


### **Step 5: Automated Deployment Workflow**

**Development Workflow**:

1. Create feature branch for infrastructure changes
2. Modify Terraform configurations
3. Push changes to trigger Spacelift planning
4. Review Terraform plan in Spacelift UI
5. Create pull request for peer review
6. Merge triggers automated deployment

**Production Deployment**:

1. Spacelift automatically detects changes in main branch
2. Executes Terraform plan with policy validation
3. Requires manual approval for production changes
4. Applies changes with full audit logging
5. Updates infrastructure state and outputs

### **Step 6: Post-Deployment Configuration**

After successful deployment, configure kubectl access:

```bash
# Update kubeconfig for cluster access
aws eks update-kubeconfig --name <cluster-name> --region <region>

# Verify cluster connectivity
kubectl get nodes
kubectl get pods --all-namespaces
```


## **Monitoring and Operations**

**Infrastructure Monitoring**:

- CloudWatch integration for EKS cluster metrics
- Spacelift drift detection for configuration changes
- Cost monitoring and alerting through AWS Cost Explorer

**Operational Excellence**:

- Automated backup strategies for persistent volumes
- Disaster recovery procedures using cross-region replication
- Security scanning integration with Spacelift policies


## **Cost Optimization**

**Resource Costs**:

- EKS cluster: \$0.10 per hour per cluster
- Fargate: Pay-per-use pricing for vCPU and memory
- EC2 instances: Variable based on node group configuration
- Data transfer: Standard AWS networking charges

**Cost Management Strategies**:

- Use Fargate for variable workloads to eliminate idle capacity costs
- Implement cluster autoscaling for optimal resource utilization
- Schedule non-production environment shutdown through Spacelift automation
- Monitor costs through AWS Cost Explorer and set up billing alerts


## **Getting Started Checklist**

- [ ] AWS account with appropriate IAM permissions
- [ ] Spacelift.io account with AWS integration configured
- [ ] Git repository connected to Spacelift
- [ ] Terraform 1.0+ installed locally for development
- [ ] AWS CLI configured for post-deployment access
- [ ] kubectl installed for cluster management

This project provides a complete foundation for modern Kubernetes infrastructure management, combining the power of Terraform, AWS EKS, and Spacelift's GitOps automation to deliver a production-ready solution that scales with your organization's needs.

<div style="text-align: center">⁂</div>

https://spacelift.io/blog/terraform-eks

https://docs.spacelift.io/integrations/cloud-providers/aws

https://github.com/cloudposse/terraform-aws-eks-fargate-profile

https://spacelift.io/blog/terraform-gitops

https://www.youtube.com/watch?v=YmdgeDnUGm0

https://github.com/cloudposse/terraform-aws-eks-cluster

https://registry.terraform.io/modules/cloudposse/components/aws/1.9.0/submodules/spacelift

https://spacelift.io/blog/bootstrap-complete-amazon-eks-clusters-with-eks-blueprints-for-terraform
