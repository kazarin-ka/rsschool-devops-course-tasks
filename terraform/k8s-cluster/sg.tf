resource "aws_security_group" "k3s_sg" {
  name        = "k3s-security-group"
  description = "Security group for K3s cluster"
  vpc_id      = data.terraform_remote_state.network-core.outputs.vpc_id

  ingress {
    description = "Allow incoming traffic for Kubernetes API server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr]
  }

  ingress {
    description = "Allow incoming traffic for node-to-node communication (port 8472 for flannel)"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr]
  }

  ingress {
    description = "Allow incoming traffic for ETCD communication (ports 2379-2380)"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr]
  }

  ingress {
    description = "Allow incoming traffic for Kubelet API (port 10250)"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr]
  }

  ingress {
    description = "Allow incoming traffic for Kube-scheduler and kube-controller-manager (ports 10251-10252)"
    from_port   = 10251
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr] # Entire VPC
  }

  ingress {
    description = "Allow incoming traffic for CoreDNS (port 53)"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr] # Entire VPC
  }

  ingress {
    description = "access to standard ssh port"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr] # Entire VPC
  }

  ingress {
    description = "port range for k3s apps"
    from_port   = 30000
    to_port     = 35000
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr] # Entire VPC
  }

  ingress {
    description = "icmp ping and other messages are allowed"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [data.terraform_remote_state.network-core.outputs.vpc_cidr] # Entire VPC
  }

  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.sec_tags,
    tomap({ Name = "k3s",
  type = "security" }))
}
