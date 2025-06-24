# Spacelift GitOps Workflow with AWS EKS + Fargate

---

## AWS EKS Infrastructure with Terraform

This repository contains Terraform templates designed to provision an Amazon Elastic Kubernetes Service (EKS) infrastructure on AWS. The modular architecture allows for easy deployment and management of scalable, secure Kubernetes clusters.

## Repository Structure

The repository is organized in a modular fashion:

- **Root directory**: Contains the main Terraform configuration files and variables
- **vpc/**: Module for creating and configuring the Virtual Private Cloud infrastructure
- **eks/**: Module for provisioning and configuring the EKS cluster and node groups

## Infrastructure Components

This Terraform project provisions the following AWS resources:

- **Virtual Private Cloud (VPC)**: Isolated network environment with public and private subnets across multiple Availability Zones.
- **IAM Roles and Policies**: Necessary permissions for EKS service and worker nodes.
- **Security Groups**: Control inbound and outbound traffic to the EKS cluster.
- **EKS Cluster**: Managed Kubernetes control plane with AWS-optimized configurations.
- **Worker Node Groups**: Auto-scaling EC2 instances to run your containerized workloads.
- **Networking Components**: Route tables, internet gateways, and NAT gateways.

The infrastructure is designed following AWS best practices for high availability, security, and scalability.

## Supported Applications

This EKS infrastructure supports a wide range of containerized applications:

- **Microservices Architectures**: Deploy complex, distributed applications with service discovery and load balancing.
- **High-Availability Web Applications**: Run web services with automatic scaling and resilience across multiple Availability Zones.
- **CI/CD Pipelines**: Enable automated building, testing, and deployment workflows.
- **Machine Learning Workloads**: Support for TensorFlow, PyTorch, and other ML frameworks with GPU capabilities.
- **Batch Processing Jobs**: Execute resource-intensive computational tasks efficiently.
- **Serverless Applications**: Can be configured to work with AWS Fargate for serverless container execution.
- **Hybrid/Multi-Cloud Deployments**: Compatible with EKS Anywhere for consistent operation across environments.

## Who Is This Project For?

This project is ideal for:

- **Cloud Engineers/Architects**: Professionals looking to implement infrastructure as code for Kubernetes deployments.
- **DevOps Teams**: Teams seeking to automate the provisioning and management of Kubernetes infrastructure.
- **Platform Engineers**: Those building reliable platforms for application teams to deploy workloads.
- **Organizations Migrating to Kubernetes**: Companies looking to adopt container orchestration with proper AWS integration.
- **Development Teams**: Groups that need a consistent, reproducible Kubernetes environment for application deployment.

## Prerequisites

- AWS account with appropriate permissions
- Terraform (version 1.0+) installed
- AWS CLI configured with appropriate credentials
- Basic understanding of Kubernetes and AWS services

## Getting Started

1. Clone this repository:

```bash
git clone https://github.com/qballscholar/spacelift-gitops-workflow.git
```

2. Navigate to the repository directory:

```bash
cd spacelift-gitops-workflow
```

3. Initialize Terraform:

```bash
terraform init
```

4. Review and modify the variables in the root directory to match your requirements
5. Plan the deployment:

```bash
terraform plan
```

6. Apply the configuration:

```bash
terraform apply
```

7. After deployment, configure kubectl using the output:

```bash
aws eks update-kubeconfig --name <cluster-name> --region <region>
```

## Cost Considerations

AWS EKS clusters cost \$0.10 per hour, plus the cost of EC2 instances for worker nodes. Be sure to monitor your usage and clean up resources when no longer needed to avoid unnecessary charges.

## Instructions: Pushing Your AWS EKS + Fargate Terraform Project to AWS via Spacelift.io

These step-by-step instructions will help you set up a GitOps workflow using Spacelift.io to provision and manage your AWS EKS infrastructure (including Fargate) with Terraform. This approach leverages Spacelift’s native GitOps capabilities to automate deployments, enforce policies, and integrate with AWS securely.

---

### **1. Prepare Your Repository**

- Ensure your repository is structured as described (root Terraform configs, `vpc/`, `eks/` modules, etc.).
- Push your latest code to your Git provider (GitHub, GitLab, Bitbucket, or Azure DevOps).

---

### **2. Set Up Spacelift Account and AWS Integration**

- Sign up or log in to Spacelift.io.
- Integrate your AWS account with Spacelift using their Cloud Integrations feature. This allows Spacelift to securely assume roles in your AWS account without static credentials, improving security and auditability.

---

### **3. Create a New Stack in Spacelift**

- Go to **Stacks** in Spacelift and click **Create Stack**.
- Select your repository and specify the path to your Terraform configuration (root or subdirectory as needed).
- Choose **Terraform** as the tool.
- In the **Behavior** tab, enable **Administrative** if you need to provision AWS resources.
- Complete the wizard and create the stack.

---

### **4. Configure Environment Variables and Inputs**

- In the stack’s **Settings > Environment** tab, add any required environment variables (e.g., `TF_VAR_*` for Terraform variables, or variables for AWS region, cluster name, etc.).
- If using Spacelift’s AWS integration, ensure the integration ID is set as an environment variable, typically `SPACELIFT_AWS_INTEGRATION_ID`.

---

### **5. Set Up State Storage**

- Configure your Terraform backend (e.g., S3 + DynamoDB) in your Terraform code for remote state storage.
- Do **not** import state into Spacelift after installation to avoid circular dependencies.

---

### **6. Define and Enforce Policies (Optional)**

- Use Spacelift’s policy engine to enforce guardrails (e.g., approval workflows, cost controls, security checks).
- Add custom policies as needed to your stack.

---

### **7. Trigger Your First Run**

- In the stack’s **Tracked Runs** tab, trigger a run.
- Spacelift will execute `terraform init`, `plan`, and you can review and approve the `apply` step via the UI or require pull request approvals (GitOps).

---

### **8. Monitor and Manage Deployments**

- Use Spacelift’s UI to monitor runs, review logs, and handle approvals.
- Integrate with notifications (Slack, email, etc.) for run status and alerts.

---

### **9. Post-Deployment: Configure kubectl**

- After successful deployment, use the Terraform output or AWS CLI to update your kubeconfig:

```
aws eks update-kubeconfig --name <cluster-name> --region <region>
```


---

### **10. Clean Up Resources**

- To destroy resources when no longer needed, trigger a `terraform destroy` run from Spacelift’s UI or via a PR.

---

## **Best Practices and Notes**

- **Use Spacelift’s AWS Integration**: Avoid static credentials; use Spacelift’s built-in AWS integration for secure, ephemeral access
- **Policy as Code**: Leverage Spacelift’s policy engine for compliance and security.
- **Stack Dependencies**: If you have multiple Terraform stacks (e.g., VPC, EKS, applications), use Spacelift’s stack dependencies to coordinate workflows.
- **Drift Detection**: Enable drift detection to be notified if resources change outside of Terraform/Spacelift.
- **Cost Monitoring**: Monitor AWS usage and destroy resources when not needed to avoid unnecessary charges.

---

## **References to Official Modules and Examples**

- For deploying Spacelift itself to EKS (self-hosted), see the [terraform-aws-eks-spacelift-selfhosted](https://github.com/spacelift-io/terraform-aws-eks-spacelift-selfhosted) module for advanced scenarios.
- For standard EKS + Fargate infrastructure, your current modular Terraform setup is suitable and supported by Spacelift’s workflow engine.

---

## **Summary Table: Spacelift GitOps Workflow Steps**

| Step | Action |
| :-- | :-- |
| 1. Repo Prep | Structure and push code to Git |
| 2. Spacelift Setup | Create account, integrate AWS |
| 3. Create Stack | Connect repo, select Terraform, set path |
| 4. Env Variables | Add `TF_VAR_*`, AWS integration ID, etc. |
| 5. State Storage | Configure backend (S3/DynamoDB); avoid importing state post-install |
| 6. Policies | Add policies for security, compliance, approvals |
| 7. Trigger Run | Plan and apply via UI or PR |
| 8. Monitor | Use UI, notifications, drift detection |
| 9. Post-Deploy | Update kubeconfig for kubectl |
| 10. Cleanup | Destroy via UI or PR when done |


---

By following these instructions, you will have a robust, automated, and secure GitOps workflow for provisioning and managing your AWS EKS infrastructure with Terraform, powered by Spacelift.io.

<div style="text-align: center">⁂</div>

https://spacelift.io/blog/terraform-gitops

https://spacelift.io/blog/bootstrap-complete-amazon-eks-clusters-with-eks-blueprints-for-terraform

https://spacelift.io/blog/terraform-eks

https://docs.spacelift.io/self-hosted/latest/installing-spacelift/reference-architecture/guides/deploying-to-eks

https://www.youtube.com/watch?v=YmdgeDnUGm0

https://docs.aws.amazon.com/eks/latest/best-practices/introduction.html

https://registry.terraform.io/providers/spacelift-io/spacelift/latest/docs/resources/aws_integration

https://dev.to/spacelift/how-to-provision-an-aws-eks-kubernetes-cluster-with-terraform-step-by-step-1k4c

https://www.youtube.com/watch?v=okmxIFt5HYk


