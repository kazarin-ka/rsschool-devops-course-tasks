# Init

This repository stores the configuration of basic entities such as S3 buckets and DynamoDB tables, 
which are necessary for the operation of other Terraform states. 

The code has been separated into a standalone repository to reduce the failure domain in case 
of an error and to avoid destroying other parts of the project.
---
**Note:** it's a first/basic folder for terraform infra. 
it creates basic infra for terraform (s3 bucket for tfstate files and Dynamodb tables for locks).
So, if you will use it from scratch, firstly commit everything in `terraform-state.tf` file. apply change first time, 
uncomment and make command `terraform init-reconfigure` to move state file to s3 bucket.

it will help you to provision infra for the first time

## Manual verification and Run

If you want manually check this code, you could apply comand from your CLI:

### Example Commands 
- **Terraform Format Check**:
  ```bash
  terraform fmt -check
  ```

- **Terraform Plan**:
  ```bash
  terraform plan -var-file *.tfvars
  ```
  
- **Terraform Apply**:
  ```bash
  terraform apply -var-file *.tfvars
  ```
  
