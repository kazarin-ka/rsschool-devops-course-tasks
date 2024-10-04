# Common tags to be assigned to all resources
locals {
  common_tags = {
    environment = var.env_type
    owner       = var.env_owner
    department  = "development"
  }

  infra_tags = merge(tomap({
    subsystem = "infrastructure" }),
  local.common_tags)

  db_tags = merge(tomap({
    subsystem = "databases" }),
  local.common_tags)

  app_tags = merge(tomap({
    subsystem = "applications" }),
  local.common_tags)

  sec_tags = merge(tomap({
    subsystem = "security" }),
  local.common_tags)
}

# Local variable for temp storage network ids during association calculation
locals {
  public_subnets = [
    for idx, net in var.networks : {
      subnet_id = aws_subnet.networks[idx].id
      az        = net.az
      cidr      = net.cidr
    }
    if net.type == "public"
  ]

  private_subnets = [
    for idx, net in var.networks : {
      subnet_id = aws_subnet.networks[idx].id
      az        = net.az
      cidr      = net.cidr
    }
    if net.type == "private"
  ]

  database_subnets = [
    for idx, net in var.networks : {
      subnet_id = aws_subnet.networks[idx].id
      az        = net.az
      cidr      = net.cidr
    }
    if net.type == "database"
  ]
}