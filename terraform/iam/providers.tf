terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.68"
    }
  }
  required_version = ">= 1.9.0"
}

# default
provider "aws" {
  alias  = "default"
  region = "eu-west-1" # Ireland

  default_tags {
    tags = local.infra_tags
  }
}
