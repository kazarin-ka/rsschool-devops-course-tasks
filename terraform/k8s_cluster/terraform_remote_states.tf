# this file contains links to remote tf sate files with outputs
# read mode: https://developer.hashicorp.com/terraform/language/state/remote-state-data

data "terraform_remote_state" "network-core" {
  backend = "s3"
  config = {
    bucket         = "ka-kazarin-edu-eu-west-1-tfstates"
    key            = "network-core.tfstate"
    region         = "eu-west-1" # Ireland
  }
}
