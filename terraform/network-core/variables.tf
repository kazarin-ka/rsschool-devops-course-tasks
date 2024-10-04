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

variable "default_description" {
  type        = string
  default     = "DO NOT EDIT MANUALLY! Managed By Terraform!"
  description = "A standard warning added to the description of all resources so that engineers do not think about changing them manually"
}

variable "all_networks" {
  description = "all network subnets CIDR"
  default     = ["0.0.0.0/0"]
}

variable "admins_ips" {
  description = "list of IPs of admin users for administration access"
  default     = ["0.0.0.0/0"]
}

variable "dns_zone_external" {
  type        = string
  default     = "network.com"
  description = "FQDN of public internal network"
}

variable "ssh_public_key" {
  description = "Public SSH Key for the new user"
  type        = string
  sensitive   = true
}

variable "vpc_settings" {
  #  type = map(any)
  description = "Basic VPC settings, described as a dictionary"
  default = {
    ipv4_cidr_block      = "192.168.0.0/22" # The IPv4 CIDR block for the VPC
    instance_tenancy     = "default"        # A tenancy option for instances launched into the VPC.
    enable_dns_support   = true
    enable_dns_hostnames = false
  }
}

variable "networks" {
  description = "Network config values in format like list(object({cidr, az, type}))"
  type = list(object({
    cidr = string
    az   = string
    type = string
  }))
  default = [
    {
      cidr = "192.168.1.0/24"
      az   = "us-west-1a"
      type = "private"
    },
    {
      cidr = "192.168.2.0/24"
      az   = "us-west-1b"
      type = "private"
    },
    {
      cidr = "192.168.3.0/24"
      az   = "us-west-1a"
      type = "public"
    },
    {
      cidr = "192.168.4.0/24"
      az   = "us-west-1b"
      type = "public"
    },
    {
      cidr = "192.168.5.0/24"
      az   = "us-west-1a"
      type = "database"
    },
    {
      cidr = "192.168.6.0/24"
      az   = "us-west-1b"
      type = "database"
    }
  ]
}
