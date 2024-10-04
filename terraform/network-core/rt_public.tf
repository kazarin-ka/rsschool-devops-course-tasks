resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Adding a route for all traffic outside the VPC through the Internet Gateway (IGW)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # Adding a route for the internal CIDR block of the VPC
  route {
    cidr_block = aws_vpc.main.cidr_block
    gateway_id = "local" # Used for routing within the VPC
  }

  tags = merge(tomap({
    Name = "Private Route Table - main",
    type = "network" }),
    local.infra_tags
  )
}

resource "aws_route_table_association" "public_subnets" {
  count = length(local.public_subnets)

  subnet_id      = local.public_subnets[count.index].subnet_id
  route_table_id = aws_route_table.public.id
}

resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}