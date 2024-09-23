env_type          = "dev"
env_owner         = "kirill.kazarin"
s3_bucket_region  = "eu-west-1" # Ireland
s3_bucket_name    = "ka-kazarin-edu-eu-west-1-tfstates"
dynamodb_tables   = [
                      "ka-kazarin-edu-terraform-init",
                      "ka-kazarin-edu-terraform-iam"
                    ]
