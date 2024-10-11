# Terraform AWS Network-Core Infrastructure

This repository contains Terraform code to provision AWS Network-Core infrastructure with a VPC, 
subnets, NAT and Internet Gateways, route tables, security groups, and EC2 instances, 
including a VPN bastion host. The configuration also includes dedicated subnets for 
databases and other core networking components.

## Table of Contents

- [Files](#files)
- [Infrastructure Overview](#infrastructure-overview)
  - [VPC](#vpc)
  - [Public and Private Hosts](#public-and-private-hosts)
  - [NAT and Internet Gateways](#nat-and-internet-gateways)
  - [Route Tables](#route-tables)
  - [Security Groups and VPN Bastion](#security-groups-and-vpn-bastion)
- [Getting Started](#getting-started)
  - [Pre-requisites](#pre-requisites)
  - [Usage](#usage)

## Files

- `ami.tf` - Configuration for finding and selecting the correct AMI for EC2 instances.
- `build_infra.sh` - A shell script for automating the deployment of the infrastructure.
- `cloud_init_vpn.yaml` - Cloud-init configuration file for setting up the VPN bastion EC2 instance.
- `ec2_vpn_bastion.tf` - Configuration for deploying the EC2 VPN bastion host.
- `igw.tf` - Configuration for creating and attaching an Internet Gateway to the VPC.
- `locals.tf` - Defines local variables used throughout the infrastructure code.
- `nacl.tf` - Configuration for setting up Network Access Control Lists (NACLs) for subnets.
- `nat_gw.tf` - Configuration for creating and configuring NAT Gateways.
- `providers.tf` - Defines the AWS provider and required configurations.
- `rt53_zones.tf` - Configuration for creating and managing Route 53 DNS zones.
- `rt_database.tf` - Route table configuration for database subnets.
- `rt_private.tf` - Route table configuration for private subnets.
- `rt_public.tf` - Route table configuration for public subnets.
- `sg_shared.tf` - Configuration for security groups shared between resources.
- `subnets.tf` - Configuration for creating public, private, and database subnets in the VPC.
- `terraform-state.tf` - Configuration for managing remote Terraform state.
- `var.tfvars` - Variables file containing user-defined values such as VPC CIDR, subnet CIDRs, and key-pairs.
- `variables.tf` - Defines input variables for the infrastructure code.
- `vpc.tf` - Configuration for creating the VPC and its related components.

## Infrastructure Overview

### VPC

The configuration creates a Virtual Private Cloud (VPC) with several subnets for different purposes, including public, private, and dedicated subnets for databases. The VPC includes both Internet and NAT Gateways for routing traffic between subnets and the internet.

### Public and Private Hosts

The infrastructure creates:
- **Public subnets**: Used for resources that need direct access to the internet, such as a VPN bastion host.
- **Private subnets**: Used for internal servers that do not require direct internet access.
- **Database subnets**: Isolated subnets dedicated to hosting database instances with additional security measures.

### NAT and Internet Gateways

- **NAT Gateway**: Allows instances in private subnets to access the internet securely, without exposing them directly.
- **Internet Gateway**: Provides public subnets with direct access to the internet.

### Route Tables

Separate route tables are defined for:
- **Public subnets**: Route outbound traffic through the Internet Gateway.
- **Private subnets**: Route outbound traffic through the NAT Gateway.
- **Database subnets**: Isolated route tables without internet access.

### Security Groups and VPN Bastion

The infrastructure includes:
- **Shared Security Groups**: Applied to EC2 instances and other resources for controlling inbound and outbound traffic.
- **VPN Bastion EC2 instance**: Deployed in a public subnet, allowing secure SSH access to private resources within the VPC. The configuration includes Cloud-init for user setup and public SSH key installation.

## Getting Started

### Pre-requisites

Before you can use the Terraform code in this repository, you must have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed.
- An AWS account with appropriate permissions to create resources.
- AWS CLI configured with your credentials.
- SSH key pair for accessing EC2 instances (can be defined in the `var.tfvars` or as an environment variable).

### Usage

1. **Clone the repository**:

 ```bash
 git clone https://github.com/your-repo/terraform-aws-infra.git
 cd terraform-aws-infra
```

2. **Set up your variables**:
Create or modify the `var.tfvars` file to define your specific settings, 
such as VPC CIDR, subnet CIDRs, and SSH key pair:
```yaml
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
db_subnet_cidrs = ["10.0.5.0/24", "10.0.6.0/24"]
key_pair = "your-key-pair-name"
  
env_type          = "dev"
env_owner         = "owner name"
dns_zone_external = "dnszone fqdn"

vpc_settings = {
  ipv4_cidr_block      = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = false
}

networks = [
  {
    cidr = "10.0.1.0/24"
    az   = "eu-west-1a"
    type = "private"
  },
  {
    cidr = "10.0.2.0/24"
    az   = "eu-west-1b"
    type = "private"
  },
  {
    cidr = "10.0.3.0/24"
    az   = "eu-west-1a"
    type = "public"
  },
  {
    cidr = "10.0.4.0/24"
    az   = "eu-west-1b"
    type = "public"
  },
  {
    cidr = "10.0.5.0/24"
    az   = "eu-west-1a"
    type = "database"
  },
  {
    cidr = "10.0.6.0/24"
    az   = "eu-west-1b"
    type = "database"
  }
]
```
3. **Enable availability verification**:

If you will need to check availability (routing, connectivity) between your networks
you can enable creating additional EC2 instances inside private networks. 
It could be done with `create_ec2_verifications_instances = true` flag

See `ec2_verification.tf` for reference


4**Initialize Terraform**:
```bash
terraform init
```
5**Plan the infrastructure**:
Run the following command to review the changes Terraform will make:
```bash
export export TF_VAR_ssh_public_key="ssh pub key for system administrator account"
terraform plan -var-file="var.tfvars"
```

6**Apply the infrastructure**:
Apply the changes to provision the infrastructure
```bash
export export TF_VAR_ssh_public_key="ssh pub key for system administrator account"
terraform apply -var-file="var.tfvars"
```

7**Access the VPN Bastion EC2 instance**:
After the infrastructure is created, you can access the VPN Bastion server via SSH:
```bash
ssh -i path_to_your_private_key system.administrator@<public_ip_of_bastion>
```

8**License**:
This project is licensed under the MIT License. 
