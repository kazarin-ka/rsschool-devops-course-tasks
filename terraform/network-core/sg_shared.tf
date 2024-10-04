# designed to use this service https://pritunl.com/
# https://docs.pritunl.com/docs/installation
resource "aws_security_group" "vpn" {
  name        = "openvpn"
  description = "sg for openvpn server based on pritunl"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allowed IP addresses for openvpn"
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = var.all_networks
  }

  ingress {
    description = "allowed IP addresses for openvpn"
    from_port   = 1194
    to_port     = 1194
    protocol    = "tcp"
    cidr_blocks = var.all_networks
  }

  ingress {
    description = "access to for lets encrypt in pritunl"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.all_networks
  }

  ingress {
    description = "access to default web ui port of pritunl"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.admins_ips
  }

  ingress {
    description = "access to modified web ui port of pritunl"
    from_port   = 9443
    to_port     = 9443
    protocol    = "tcp"
    cidr_blocks = var.all_networks
  }

  ingress {
    description = "access to ssh (modified to prevent access from non-authorized users)"
    from_port   = 32100
    to_port     = 32100
    protocol    = "tcp"
    cidr_blocks = var.admins_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.all_networks
  }

  tags = merge(local.sec_tags,
    tomap({ Name = "openvpn",
  type = "security" }))
}