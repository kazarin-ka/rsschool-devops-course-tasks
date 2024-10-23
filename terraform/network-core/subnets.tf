resource "aws_subnet" "networks" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.networks)
  cidr_block        = var.networks[count.index].cidr
  availability_zone = var.networks[count.index].az

  tags = merge(tomap({
    # Name format will be "<AZ ID>-<type>-<number>"
    Name = format("%s-%s-%02d",
      var.networks[count.index].az,
      var.networks[count.index].type,
      # Count the number of networks of the same type before the current network to assign a sequence number
      length([for i in range(0, count.index) : var.networks[i]
        if var.networks[i].type == var.networks[count.index].type
      ]) + 1
    )
    description = var.default_description
    type = "network" }),
    local.infra_tags
  )
}
