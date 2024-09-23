locals {
  # Common tags to be assigned to all resources
  common_tags = {
    environment = var.env_type
    owner       = var.env_owner
    department  = "development"
  }

  infra_tags    = merge(tomap({
                        subsystem = "infrastructure"}),
                        local.common_tags)

  db_tags       = merge(tomap({
                        subsystem = "databases"}),
                        local.common_tags)

  app_tags      = merge(tomap({
                        subsystem = "applications"}),
                        local.common_tags)

  sec_tags      = merge(tomap({
                        subsystem = "security"}),
                        local.common_tags)
}