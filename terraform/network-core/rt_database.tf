resource "aws_route_table" "database" {
  for_each = { for idx, subnet in local.database_subnets : idx => subnet }
  vpc_id   = aws_vpc.main.id

  # Adding a route for the internal CIDR block of the VPC
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local" # Used for routing within the VPC
  }

  tags = merge(tomap({
    Name = format("Database Route Table %s", each.value.az),
    type = "network" }),
    local.infra_tags
  )
}


resource "aws_route_table_association" "database_subnets" {
  for_each = aws_route_table.database

  subnet_id      = local.database_subnets[tonumber(each.key)].subnet_id
  route_table_id = each.value.id
}
