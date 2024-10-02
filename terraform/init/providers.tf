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
  region = var.s3_bucket_region

  default_tags {
    tags = local.infra_tags
  }
}

# alternative for specific resources like CloudFront
provider "aws" {
  alias  = "Virginia"
  region = "us-east-1"

  default_tags {
    tags = local.infra_tags
  }
}
