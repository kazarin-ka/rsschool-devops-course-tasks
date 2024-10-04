# Create Network ACL for VPC
resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "My Network ACL - Allow All"
  }
}

# NACL rule to allow all incoming traffic (Ingress)
resource "aws_network_acl_rule" "allow_all_inbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = false # Ingress traffic
  protocol       = "-1"  # all protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0" # Allow all IP-addr
  from_port      = 0
  to_port        = 0
}

# NACL rule to allow all outgoing traffic (Egress)
resource "aws_network_acl_rule" "allow_all_outbound" {
  network_acl_id = aws_network_acl.main.id
  rule_number    = 100
  egress         = true # Egress  traffic
  protocol       = "-1" # all protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0" # Allow all IP-addr
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_association" "public_subnet_acl_association" {
  count = length(local.public_subnets)

  subnet_id      = local.public_subnets[count.index].subnet_id
  network_acl_id = aws_network_acl.main.id
}

resource "aws_network_acl_association" "private_subnet_acl_association" {
  count = length(local.private_subnets)

  subnet_id      = local.private_subnets[count.index].subnet_id
  network_acl_id = aws_network_acl.main.id
}