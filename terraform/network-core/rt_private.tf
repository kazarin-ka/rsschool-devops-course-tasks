resource "aws_route_table" "private" {
  for_each = { for idx, subnet in local.private_subnets : idx => subnet }
  vpc_id   = aws_vpc.main.id

  #Adding a route for all traffic outside the VPC through the NAT Gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[each.key].id
  }

  # Adding a route for the internal CIDR block of the VPC
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local" # Used for routing within the VPC
  }

  tags = merge(tomap({
    Name = format("Private Route Table %s", each.value.az),
    type = "network" }),
    local.infra_tags
  )
}


resource "aws_route_table_association" "private_subnets" {
  for_each = aws_route_table.private

  subnet_id      = local.private_subnets[tonumber(each.key)].subnet_id
  route_table_id = each.value.id
}
