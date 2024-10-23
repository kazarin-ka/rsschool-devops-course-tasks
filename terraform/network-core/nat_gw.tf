# NatGw must be created 1 per AZ, in our case it means - per public network
# 1 NatGw for all infra will works but it's not an HA variant

# Elastic IP для NAT Gateway
resource "aws_eip" "natgw" {
  for_each = { for idx, subnet in local.public_subnets : idx => subnet }
  domain   = "vpc"

  tags = merge(tomap({
    Name = "${var.env_owner}-${var.env_type}-natgw",
    type = "network" }),
    local.infra_tags
  )
}

# NAT Gateway placed in public networks
resource "aws_nat_gateway" "ngw" {
  for_each      = aws_eip.natgw
  allocation_id = each.value.id                                      # Attach Elastic IP to NAT Gateway
  subnet_id     = local.public_subnets[tonumber(each.key)].subnet_id # connect with appropriate public network

  tags = merge(tomap({
    Name = "${var.env_owner}-${var.env_type}",
    type = "network" }),
    local.infra_tags
  )
}

