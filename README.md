# MLOps Infrastructure using Terraform

## 1. Project Overview
This repository contains a production-grade, modular Terraform configuration to provision and manage AWS resources for an end-to-end MLOps platform. By defining Infrastructure as Code (IaC), this project automates the deployment of secure, scalable, and highly available environments (Dev, Stage, Prod) for model training, inference, and orchestration pipelines.

## 2. Architecture Diagram (ASCII)
```
                          +-----------------------------------+
                          |            Terraform              |
                          +-----------------------------------+
                                            |
                                            v
                          +-----------------------------------+
                          |   Remote Backend (S3 + DynamoDB)  |
                          +-----------------------------------+
                                            |
                                            v
  +---------------------------------------------------------------------------------+
  |                                   AWS Cloud                                     |
  |                                                                                 |
  |  +-----------------------+   +-----------------------+   +-------------------+  |
  |  |    S3 Bucket          |   |     ECR Repository    |   | CloudWatch Log    |  |
  |  | (Dataset & Artifacts) |   | (Docker Images)       |   | Group (Monitoring)|  |
  |  +-----------------------+   +-----------------------+   +-------------------+  |
  |              ^                           ^                         ^            |
  |              |                           |                         |            |
  |              +---------------------------+-------------------------+            |
  |                                          |                                      |
  |                                          v                                      |
  |  +---------------------------------------------------------------------------+  |
  |  |                           SageMaker Domain                                |  |
  |  |  +----------------------------+           +----------------------------+  |  |
  |  |  |   SageMaker User Profile   |           | SageMaker Notebook Instance|  |  |
  |  |  +----------------------------+           +----------------------------+  |  |
  |  +---------------------------------------------------------------------------+  |
  |                                          ^                                      |
  |                                          | (Trigger Inference/Pipeline)         |
  |                                          v                                      |
  |  +---------------------------------------------------------------------------+  |
  |  |                            Lambda Function                                |  |
  |  +---------------------------------------------------------------------------+  |
  |                                          ^                                      |
  |                                          | (Assume Exec Roles)                  |
  |                                          v                                      |
  |  +---------------------------------------------------------------------------+  |
  |  |                        IAM Roles & Security Policies                      |  |
  |  +---------------------------------------------------------------------------+  |
  +---------------------------------------------------------------------------------+
```

## 3. Key Features
* **Modular Infrastructure**: Reusable Terraform modules for modular service provisioning.
* **State Management & Locking**: Remote state storage using AWS S3 coupled with DynamoDB for state locking to prevent concurrent apply operations.
* **Multi-Environment Setup**: Dev, Stage, and Prod environments separated cleanly through folders.
* **Least-Privilege Security**: Custom IAM roles and policies tailored for SageMaker and Lambda execution with narrow scopes.
* **Fully Auditable**: Enabled S3 bucket versioning and centralized CloudWatch log groups for metrics and tracking.

## 4. Technology Stack
* **Infrastructure as Code**: Terraform (>= 1.3.0)
* **Cloud Platform**: AWS
* **ML Orchestration**: AWS SageMaker (Domain, User Profile, Notebooks)
* **Compute**: AWS Lambda
* **Storage & Containers**: AWS S3, AWS ECR
* **Monitoring**: AWS CloudWatch

## 5. Project Structure
```
terraform-mlops-infrastructure/
├── backend/                  # Bootstrapping S3 & DynamoDB state locking
│   ├── s3.tf                 # S3 bucket for tfstate
│   └── dynamodb.tf           # DynamoDB table for state locking
├── modules/                  # Reusable Infrastructure Modules
│   ├── s3/                   # S3 Bucket module (versioned, encrypted)
│   ├── ecr/                  # ECR Docker container registry
│   ├── sagemaker/            # SageMaker Domain, user profile, and notebook
│   ├── lambda/               # Lambda trigger function
│   ├── cloudwatch/           # Logging & monitoring groups
│   └── iam/                  # IAM roles & least-privilege policies
├── environments/             # Environment configurations
│   ├── dev/                  # Development environment deployment
│   ├── stage/                # Staging environment deployment
│   └── prod/                 # Production environment deployment
├── main.tf                   # Root main.tf coordinating all modules
├── variables.tf              # Root variables definition
├── outputs.tf                # Root outputs definition
├── providers.tf              # AWS provider specifications
└── terraform.tfvars          # Root example variables values
```

## 6. Infrastructure Components

### S3
Used as the central Data Lake for storing datasets, training scripts, and serialized model artifacts. It implements SSE-KMS encryption and public access blocks to ensure no data exposure.

### ECR
Hosts custom Docker container images used for training jobs, hyperparameter tuning, and SageMaker model hosting. Implements scanning-on-push to proactively spot security vulnerabilities.

### SageMaker
The core MLOps workspace containing a SageMaker Domain for collaborative development, a User Profile for developer access, and SageMaker Notebook Instances for interactive data exploration and model development.

### Lambda
A trigger function acting as a bridge to start SageMaker training pipelines or trigger batch inference when new data is uploaded to S3.

### CloudWatch
Provides comprehensive log groups for auditing Lambda execution, model logs, and SageMaker pipeline runs with specific log retention rules per environment.

### IAM
Enforces the principle of least-privilege, providing distinct execution roles for SageMaker and Lambda services with scoped-down S3 and CloudWatch access.

## 7. Remote Backend Configuration
This project uses an S3 Remote Backend combined with a DynamoDB lock table to ensure:
* **Durability**: State files are saved off developer machines, preventing local file corruption.
* **Collaboration**: Multiple engineers can work on the same infrastructure securely.
* **State Locking**: DynamoDB registers lock IDs during execution, preventing race conditions or partial resource updates.

Configure the backend block in `providers.tf`:
```hcl
backend "s3" {
  bucket         = "mlops-tf-remote-state-bucket"
  key            = "environments/dev/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "mlops-tf-state-locks"
  encrypt        = true
}
```

## 8. Multi-Environment Setup (Dev, Stage, Prod)
Environments are segregated inside the `environments/` directory. Each environment targets its specific config folder:
* **Dev**: Deploy test infrastructure using cost-effective micro-instances (e.g., `ml.t3.medium`).
* **Stage**: Pre-production mirroring prod settings for staging integrations.
* **Prod**: High availability setups with larger instance sizes (e.g., `ml.m5.xlarge`) and non-destructive delete features (`force_destroy = false` on S3).

## 9. Prerequisites
* **Terraform CLI** (>= 1.3.0) installed locally.
* **AWS CLI** configured with appropriate permissions.
* An active AWS account.

## 10. Setup Instructions
1. Navigate to the backend bootstrap directory and run the initialization:
   ```bash
   cd backend
   terraform init
   terraform apply
   ```
2. Retrieve the generated S3 bucket and DynamoDB table names.
3. Uncomment the backend blocks in your environment's `providers.tf` files and add these values.
4. Navigate to the desired environment (e.g., `environments/dev/`):
   ```bash
   cd ../environments/dev
   terraform init
   ```

## 11. Terraform Workflow

### terraform init
Initializes the working directory, downloads required provider plugins, and connects to the S3 remote state backend.
```bash
terraform init
```

### terraform validate
Validates the syntax and structure of the Terraform code.
```bash
terraform validate
```

### terraform plan
Executes a dry-run to show changes that will be applied to the AWS infrastructure.
```bash
terraform plan
```

### terraform apply
Applies changes to AWS and provisions the resources.
```bash
terraform apply -auto-approve
```

### terraform destroy
Cleans up and removes all provisioned resources from your AWS account.
```bash
terraform destroy -auto-approve
```

## 12. Security Best Practices
* **Least-Privilege Roles**: Execution roles restrict AWS services to only access designated resources.
* **S3 Block Public Access**: Configured blocks at the API level to forbid public read/write requests.
* **ECR Scanning**: Enabled vulnerability scanning to inspect container images during push operations.

## 13. Cost Optimization
* **Instance Selection**: Uses burstable instances (`ml.t3.medium`) in non-production environments.
* **ECR Lifecycle Policies**: Automatically cleans up older untagged container images to reduce storage costs.
* **CloudWatch Retention**: Restricted CloudWatch logging histories to 7 days in Dev and Stage.

## 14. Real-World MLOps Workflow
1. An engineer modifies a training script and pushes a container image to AWS ECR.
2. The image push triggers training pipelines within the SageMaker Domain workspace.
3. A Lambda function triggers inference or pipelines whenever a new dataset is uploaded to the S3 bucket.
4. All pipeline execution events and model server outputs are captured in CloudWatch Log Groups for continuous monitoring.

## 15. Learning Outcomes
* Designed modular and reusable infrastructure blueprints using Terraform.
* Configured AWS IAM policies adhering to the principle of least privilege.
* Implemented production-ready remote state management patterns.
* Understood resource orchestration of SageMaker, ECR, and S3 for machine learning lifecycles.

## 16. Future Improvements
* Integrate VPC peering or PrivateLink endpoints for internal private routing.
* Incorporate Terraform linting and security scans via `tflint` and `tfsec` in CI/CD.
* Add model drift detection metrics linked to CloudWatch alerts.
