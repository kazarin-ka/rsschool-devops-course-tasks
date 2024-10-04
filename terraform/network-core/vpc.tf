# vpc and any other infra for stage even for prod must be located in separate aws accounts
# it's more secure and more useful for billing

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_settings.ipv4_cidr_block
  instance_tenancy     = var.vpc_settings.instance_tenancy
  enable_dns_support   = var.vpc_settings.enable_dns_support
  enable_dns_hostnames = var.vpc_settings.enable_dns_hostnames

  tags = merge(tomap({
    Name = "${var.env_owner}-${var.env_type}",
    type = "storage" }),
    local.infra_tags
  )
}