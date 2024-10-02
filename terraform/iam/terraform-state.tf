terraform {
  backend "s3" {
    bucket         = "ka-kazarin-edu-eu-west-1-tfstates"
    key            = "iam.tfstate"
    region         = "eu-west-1" # Ireland
    encrypt        = true
    dynamodb_table = "ka-kazarin-edu-terraform-iam"
  }
}