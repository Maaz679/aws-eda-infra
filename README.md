# AWS EDA Infrastructure (Terraform)

Infrastructure-as-code configuration for provisioning a secure cloud compute and storage environment on AWS, designed for EDA (Electronic Design Automation) workloads.

Built with Terraform to demonstrate IaC principles for managing compute, networking, and storage resources in a repeatable, version-controlled workflow.

## Architecture
```
+-----------------------------------------------------+
|  VPC (10.0.0.0/16)                                  |
|                                                     |
|  +----------------------+  +----------------------+ |
|  |  Public Subnet       |  |  Private Subnet      | |
|  |  10.0.1.0/24         |  |  10.0.2.0/24         | |
|  |                      |  |                      | |
|  |  +----------------+  |  |  (reserved for       | |
|  |  | EC2 Compute    |  |  |   internal services) | |
|  |  | Node (t2.micro)|  |  |                      | |
|  |  +----------------+  |  |                      | |
|  +----------+----------+  +----------------------+ |
|             |                                       |
|  +----------+----------+                            |
|  |  Internet Gateway    |                            |
|  +----------------------+                            |
|                                                     |
|  +----------------------+                            |
|  |  S3 Bucket           |                            |
|  |  (encrypted, version |                            |
|  |   controlled, no     |                            |
|  |   public access)     |                            |
|  +----------------------+                            |
+-----------------------------------------------------+
```

## What This Provisions

| Resource | Purpose |
|----------|---------|
| **VPC** | Isolated network with DNS support |
| **Public Subnet** | Hosts compute node with internet access |
| **Private Subnet** | Reserved for internal-only resources |
| **Internet Gateway + Route Table** | Routes public subnet traffic to the internet |
| **Security Group** | Firewall restricting SSH to a single IP (CIDR /32) |
| **EC2 Instance** | Ubuntu 24.04 compute node on t2.micro |
| **S3 Bucket** | Artifact storage with AES-256 encryption, versioning, and all public access blocked |

## Security Considerations

- SSH access is restricted to a single IP address via /32 CIDR block
- S3 bucket enforces server-side encryption (AES-256)
- S3 public access is fully blocked (ACLs + policies)
- Bucket versioning is enabled for artifact integrity
- Sensitive values (terraform.tfvars) are excluded from version control

## Usage

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with valid credentials
- An AWS account with permissions to create VPC, EC2, and S3 resources

### Deploy
```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/aws-eda-infra.git
cd aws-eda-infra

# Create your variables file
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# Initialize, preview, and deploy
terraform init
terraform plan
terraform apply
```

### Tear Down
```bash
terraform destroy
```

## Deployment Verification

Successfully deployed and verified on AWS (us-west-2):

![EC2 instance running](docs/ec2-running.png)

## Project Structure
```
aws-eda-infra/
├── main.tf              # Core infrastructure definitions
├── variables.tf         # Input variable declarations
├── outputs.tf           # Output values displayed after deploy
├── terraform.tfvars.example  # Example variable values (safe to commit)
├── .gitignore           # Excludes state files and secrets
└── README.md
```

## Technologies

- **Terraform** — Infrastructure as Code
- **AWS VPC** — Network isolation
- **AWS EC2** — Compute
- **AWS S3** — Encrypted object storage
- **AWS IAM** — Access control
