variable "env_type" {
  type        = string
  default     = "FIXME"
  description = "environment type: dev, stage, prod"
}

variable "env_owner" {
  type        = string
  default     = "FIXME"
  description = "Who own infrastructure and project. No spaces, only lower case. Underscore is acceptable"
}

variable "dynamodb_tables" {
  type        = list(any)
  description = "List of DynamoDB tables to store terraform Locks"
  default     = []
}

variable "s3_bucket_name" {
  type        = string
  description = "The name of S3 bucket where tfstate will be stored."
  default     = "FIXME"
}

variable "s3_bucket_region" {
  description = "AWS region where S3 bucket will be hosted in."
  type        = string
  default     = "FIXME"
}
