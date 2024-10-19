resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(tomap({
    Name = "${var.env_owner}-${var.env_type}",
    type = "network" }),
    local.infra_tags
  )
}