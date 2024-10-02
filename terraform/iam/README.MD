# IAM

This directory contains configurations related to IAM settings. 

A separate Terraform project was created to isolate the configuration of policies, 
roles, and users from other configurations, in order to minimize damage in case of 
failure and potentially enhance security in the future by applying stricter 
permissions to read its state file
---
**Note:** Before create any resources from this repo, be sure you've applied al lchanges from `init` folder!

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
  