### These instances will be used only for network connectivity and routing verifications
### They will be auto deployed in all non-public networks if create_ec2_verifications_instances = true

resource "aws_instance" "private_instances" {
  count = var.create_ec2_verifications_instances ? length(local.private_subnets) : 0

  ami           = data.aws_ami.ubuntu_24_04.id
  instance_type = "t3a.nano"
  subnet_id     = local.private_subnets[count.index].subnet_id
  security_groups = [aws_security_group.ec2_verification.id]
  tenancy       = var.vpc_settings.instance_tenancy
  user_data = templatefile("cloud_init_verification.yaml", {
    ssh_public_key = var.ssh_public_key
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = merge(tomap({
    Name = "${var.env_type}-private-instance-${count.index}",
    type = "network" }),
    local.infra_tags
  )
}

resource "aws_instance" "database_instances" {
  count = var.create_ec2_verifications_instances ? length(local.database_subnets) : 0

  ami           = data.aws_ami.ubuntu_24_04.id
  instance_type = "t3a.nano"
  subnet_id     = local.database_subnets[count.index].subnet_id
  security_groups = [aws_security_group.ec2_verification.id]
  tenancy       = var.vpc_settings.instance_tenancy
  user_data = templatefile("cloud_init_verification.yaml", {
    ssh_public_key = var.ssh_public_key
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = merge(tomap({
    Name = "${var.env_type}-database-instance-${count.index}",
    type = "network" }),
    local.infra_tags
  )
}
