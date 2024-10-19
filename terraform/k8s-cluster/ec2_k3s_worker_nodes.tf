resource "aws_instance" "k3s_worker" {
  count                  = var.k3s_worker_node_count
  ami                    = data.terraform_remote_state.network-core.outputs.ubuntu_24_04_ami_id
  ebs_optimized          = true
  instance_type          = var.k8s_worker_node_type
  tenancy                = var.k8s_worker_node_tenancy
  subnet_id              = local.k3s_worker_node_subnets_distribution[count.index] # Network selection per instance
  vpc_security_group_ids = [aws_security_group.k3s_sg.id]

  user_data = templatefile("cloud_init_k3s.yaml", {
    hostname                 = "${var.env_type}-k3s_master${format("%02d", count.index + 1)}",
    ssh_public_key           = var.ssh_public_key,
    grafana_cloud_token_k3s  = var.grafana_cloud_token_k3s,
    grafana_cloud_token_node = var.grafana_cloud_token_node
  })

  root_block_device {
    volume_type           = var.k8s_worker_node_disk.type
    volume_size           = var.k8s_worker_node_disk.size
    delete_on_termination = true
  }

  tags = merge(tomap({
    Name = "${var.env_type}-k3s_worker${format("%02d", count.index + 1)}", # Personal instance name
    type = "platform" }),
    local.infra_tags
  )
}

