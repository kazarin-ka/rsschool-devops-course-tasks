env_type          = "dev"
env_owner         = "kirill.kazarin"
dns_zone_external = "rss.kirill.kazarin.edu"
# ssh_public_key = <Myst be set as "export TF_VAR_ssh_public_key">
# create_ec2_verifications_instances = true ## uncomment only if you need VMs to check internal routing and connectivity
vpc_settings = {
  ipv4_cidr_block      = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = false
}

# https://gist.github.com/karstenmueller/98381c897178a260be8c08f98ffe2c3e
networks = [
  {
    cidr = "10.0.1.0/24"
    az   = "eu-west-1a"
    type = "private"
  },
  {
    cidr = "10.0.2.0/24"
    az   = "eu-west-1b"
    type = "private"
  },
  {
    cidr = "10.0.3.0/24"
    az   = "eu-west-1a"
    type = "public"
  },
  {
    cidr = "10.0.4.0/24"
    az   = "eu-west-1b"
    type = "public"
  },
  {
    cidr = "10.0.5.0/24"
    az   = "eu-west-1a"
    type = "database"
  },
  {
    cidr = "10.0.6.0/24"
    az   = "eu-west-1b"
    type = "database"
  }
]
