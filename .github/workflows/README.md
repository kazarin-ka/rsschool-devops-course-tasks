# Terraform Deployment using GitHub Actions

This repository uses **GitHub Actions** to manage infrastructure deployment with **Terraform**. 
The workflow includes several steps: **format checking**, **planning**, and **applying** 
Terraform configurations. These steps are described in single file for the first time becaus 
it's my first exp with github worflow.

## Workflow Structure

In general. workflow file inclused 2 separate parralel flow - for Init and IAM projects
The main workflow `terraform-main.yml` file include pipeline description for both.

## Workflow Details

### 1. Terraform Check

- **Description**: This workflow checks the formatting of the Terraform code 
using `terraform fmt -check`.
- **Usage**: It runs on both `init` and `iam` subdirectories.

### 2. Terraform Plan

- **Description**: This workflow generates a Terraform plan to show potential changes to the 
infrastructure. It also saves plan results in output artifact for each step to apply on the next step
- **Usage**: It runs on both `init` and `iam` subdirectories after the `terraform-check` job.

### 3. Terraform Apply

- **Description**: This workflow applies the Terraform configuration changes to the infrastructure. 
It is triggered only on a `push` event to the `main` branch. It will aplly only changes saved as artifacts on the previous steps
- **Usage**: It runs after the `terraform-plan` job for both `init` and `iam` subdirectories.

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
  terraform plan -out=tfplan -input=false -var-file *.tfvars
  ```
  
- **Terraform Apply**:
  ```bash
  terraform apply -input=false tfplan
  ```

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