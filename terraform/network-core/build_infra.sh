#!/usr/bin/env bash
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

terraform init -input=false

terraform fmt
terraform fmt -check

terraform plan -out=tfplan \
          -input=false \
          -var-file *.tfvars

terraform apply \
        -input=false \
        tfplan