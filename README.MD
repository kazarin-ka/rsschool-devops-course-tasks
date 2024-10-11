# Terraform Infrastructure Management

This repository is designed to manage and apply Terraform configurations for various parts of the infrastructure. The project is divided into two main directories: `.github` for workflows and `terraform` for infrastructure code, which is separated into two different Terraform projects.

## Project Structure

The repository is structured as follows:

### 1. `.github/`
This directory contains GitHub Actions workflows responsible for applying changes to the Terraform code. The workflows automate the process of formatting, planning, and applying Terraform configurations upon certain events, such as pull requests or pushes to the `main` branch.

**Key components**:
- **Workflows**: These handle the execution of `terraform fmt`, `terraform plan`, and `terraform apply` commands. The workflows ensure that any changes to the Terraform infrastructure are tested and deployed correctly through a continuous integration pipeline.

### 2. `terraform/`
This directory contains two separate Terraform projects, each focused on different aspects of the infrastructure. The projects are split to improve code management and reduce the blast radius in case of an error (e.g., an incorrect command in a GitHub Action workflow or a code edit mistake).

#### a. `init/`
This project describes the **initial infrastructure setup** needed for managing Terraform state and locking. It includes:
- An **S3 bucket** for storing Terraform state files.
- A **DynamoDB table** for handling state locks to ensure safe concurrent operations.

**Note:** Creation of your infrastructure must be started from this folder's code applying!

#### b. `iam/`
This project handles the **Identity and Access Management (IAM)** setup. Currently, it includes:
- **Users** and basic **IAM policies**.

In the future, this project will also manage:
- **Groups** and more complex role-based access control (RBAC) setups.
- **Roles** for various users and services.

By separating the `init` and `iam` Terraform projects, we achieve better code organization and reduce potential risks. For example, an error in the IAM configuration or a mistake in editing the GitHub Actions workflow would not directly impact the more sensitive components of the infrastructure, such as the state management in the `init` project.

#### c. `network-core/`
This project handle core(basic) network infrastructure, including:
- vpc
- networks
- routing tables
- Internet gateway
- Nat Gateway
- bastion/vpn host
- Network ACL
- Route53 (DNS) zones

Separating this project from `init` and `iam` Terraform projects (and other ones in future) 
decrease the blast radius in case of any mistakes with terraform code.
And we can achieve better code organization and reduce potential risks. 
For example, an error in the IAM configuration or a mistake in editing the GitHub Actions workflow would not directly impact the more sensitive components of the infrastructure, such as the network infrastructure.


## Rationale for Separation

The `network-core`, `init` and `iam` projects are separated to provide:
- **Better management of infrastructure components**: Keeping the state management (S3 bucket and DynamoDB) separate from IAM-related configurations allows for easier maintenance.
- **Isolation of failures**: If an error occurs in one project, it will not affect the other. For example, a mistake in the `iam` project would not impact the critical infrastructure that manages Terraform states and locks.
- **Smaller blast radius**: In case of a failure in code or workflow, the impact is limited to the scope of the project, reducing the overall risk to the infrastructure.

## Usage

- **Workflow**: When a pull request or push is made to the `main` branch, GitHub Actions automatically triggers the workflow to check, plan, and apply Terraform changes.
- **Terraform Projects**:
  - `init/`: Run this project first to set up the initial infrastructure for managing Terraform states.
  - `iam/`: Once the initial infrastructure is in place, manage users, policies, and roles here.
  - `network-core/`:  Once the initial infrastructure is in place, manage any network related items here
