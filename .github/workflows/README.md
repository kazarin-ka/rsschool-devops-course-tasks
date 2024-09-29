# Terraform Deployment using GitHub Actions

This repository uses **GitHub Actions** to manage infrastructure deployment with **Terraform**. 
The workflow is broken down into several steps: **format checking**, **planning**, and **applying** 
Terraform configurations. These steps are modularized into separate workflows for better organization 
and maintainability.

## Workflow Structure

The workflows are divided into three separate files for each stage of the Terraform deployment 
process:

1. **Terraform Check** (`terraform-check.yml`): Checks the format of Terraform files.
2. **Terraform Plan** (`terraform-plan.yml`): Generates a Terraform plan to preview 
infrastructure changes.
3. **Terraform Apply** (`terraform-apply.yml`): Applies the changes to the infrastructure.

The main workflow `terraform-main.yml` calls these individual workflows and coordinates the process.

### Files Overview:

- **`.github/workflows/terraform-check.yml`**: 
  - Validates the formatting of Terraform configuration files using `terraform fmt -check`.
  - Runs in both `init` and `iam` subdirectories.
  
- **`.github/workflows/terraform-plan.yml`**:
  - Runs `terraform plan` to preview the changes for both `init` and `iam` subdirectories.
  
- **`.github/workflows/terraform-apply.yml`**:
  - Executes `terraform apply -auto-approve` to deploy changes to the infrastructure when 
  changes are pushed to the `main` branch.

- **`.github/workflows/terraform-main.yml`**:
  - The main workflow that orchestrates the other workflows, ensuring the steps are executed in order:
    - **Check**: Validates formatting.
    - **Plan**: Previews the changes.
    - **Apply**: Deploys the changes (only on `push` events).

## Workflow Details

### 1. Terraform Check

- **Path**: `.github/workflows/terraform-check.yml`
- **Description**: This workflow checks the formatting of the Terraform code 
using `terraform fmt -check`.
- **Usage**: It runs on both `init` and `iam` subdirectories.

### 2. Terraform Plan

- **Path**: `.github/workflows/terraform-plan.yml`
- **Description**: This workflow generates a Terraform plan to show potential changes to the 
infrastructure.
- **Usage**: It runs on both `init` and `iam` subdirectories after the `terraform-check` job.

### 3. Terraform Apply

- **Path**: `.github/workflows/terraform-apply.yml`
- **Description**: This workflow applies the Terraform configuration changes to the infrastructure. 
It is triggered only on a `push` event to the `main` branch.
- **Usage**: It runs after the `terraform-plan` job for both `init` and `iam` subdirectories.

### 4. Terraform Main

- **Path**: `.github/workflows/terraform-main.yml`
- **Description**: The main workflow file that coordinates the other workflows. 
It ensures that `terraform-check`, `terraform-plan`, and `terraform-apply` jobs run in sequence.

## Running the Workflow

The workflow is triggered on the following events:

- **Pull Request**: On pull requests to the `main` branch, the `terraform-check` 
and `terraform-plan` steps are run to validate changes and preview the infrastructure modifications.
- **Push**: On push to the `main` branch, after the successful `terraform-check` 
and `terraform-plan`, the `terraform-apply` step is run to deploy the changes.

### Example Commands in Workflows:
- **Terraform Format Check**:
  ```bash
  terraform fmt -check
  ```

- **Terraform Plan**:
  ```bash
  terraform plan
  ```
  
- **Terraform Apply**:
  ```bash
  terraform apply -auto-approve
  ```
  
## How to Modify
- To modify a specific part of the workflow (e.g., check, plan, or apply), 
update the corresponding YAML file under `.github/workflows/`.
- The main workflow (`terraform-main.yml`) will automatically call the individual 
workflows in the correct sequence.

## How to Modify
- **Terraform version:** You can update the Terraform version used by editing the 
`terraform_version` field in each workflow file:
```yaml
  uses: hashicorp/setup-terraform@v3
  with:
    terraform_version: 1.9.6  # Change this to your desired version
  ```
- **Working Directories:** If the structure of the Terraform directories changes, update the 
`working-directory` fields in each workflow file to reflect the new paths.

# Conclusion

This repository is set up to modularize the Terraform deployment process using GitHub Actions. By splitting the workflow into reusable parts (check, plan, and apply), the configuration remains clean and maintainable, while ensuring that all 
Terraform changes are validated and applied correctly.