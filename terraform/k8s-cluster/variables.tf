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

variable "k3s_master_node_count" {
  description = "Number of instances to create"
  type        = number
  default     = 0
}

variable "k8s_master_node_type" {
  description = "instance type for k8s node"
  default     = "t3a.small"
}

variable "k8s_master_node_tenancy" {
  description = "provision tenancy for k8s node"
  default     = "default"
}

variable "k8s_master_node_disk" {
  description = "disk type for k8s node"
  default = {
    size = 30
    type = "gp3"
  }
}

variable "k3s_worker_node_count" {
  description = "Number of kuber workers nodes to create"
  type        = number
  default     = 0
}

variable "k8s_worker_node_type" {
  description = "instance type for k8s node"
  default     = "t3a.small"
}

variable "k8s_worker_node_tenancy" {
  description = "provision tenancy for k8s node"
  default     = "default"
}

variable "k8s_worker_node_disk" {
  description = "disk type for k8s node"
  default = {
    size = 50
    type = "gp3"
  }
}

variable "ssh_public_key" {
  description = "Public SSH Key for the new user"
  type        = string
  sensitive   = true
}

variable "grafana_cloud_token_k3s" {
  description = "token to provision integration with grafana cloud for k3s monitoring"
  type        = string
  sensitive   = true
}

variable "grafana_cloud_token_node" {
  description = "token to provision integration with grafana cloud for linux node monitoring"
  type        = string
  sensitive   = true
}