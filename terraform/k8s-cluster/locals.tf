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

# Local variable for cyclic network ids redistribution
locals {
  k3s_master_node_subnets_distribution = [
    for idx in range(var.k3s_master_node_count) : data.terraform_remote_state.network-core.outputs.private_subnets[idx % length(data.terraform_remote_state.network-core.outputs.private_subnets)].subnet_id
  ]
}

# Local variable for cyclic network ids redistribution
locals {
  k3s_worker_node_subnets_distribution = [
    for idx in range(var.k3s_worker_node_count) : data.terraform_remote_state.network-core.outputs.private_subnets[idx % length(data.terraform_remote_state.network-core.outputs.private_subnets)].subnet_id
  ]
}