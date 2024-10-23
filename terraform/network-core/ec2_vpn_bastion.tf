resource "aws_network_interface" "vpn_nic0" {
  description       = var.default_description
  subnet_id         = local.public_subnets[0].subnet_id
  security_groups   = [aws_security_group.vpn.id]
  source_dest_check = false

  tags = merge(tomap({
    Name = "${var.env_type}-vpn01",
    type = "service" }),
    local.sec_tags
  )
}

resource "aws_eip" "vpn_eip" {
  domain = "vpc"
  tags = merge(tomap({
    Name = "${var.env_type}-vpn01",
    type = "service" }),
    local.sec_tags
  )
}

resource "aws_eip_association" "vpn_eip_association" {
  instance_id   = aws_instance.vpn.id
  allocation_id = aws_eip.vpn_eip.id
}

resource "aws_instance" "vpn" {
  ami           = data.aws_ami.ubuntu_24_04.id
  ebs_optimized = true
  instance_type = "t3a.micro"
  tenancy       = var.vpc_settings.instance_tenancy
  user_data = templatefile("cloud_init_vpn.yaml", {
    ssh_public_key = var.ssh_public_key
  })

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  network_interface {
    device_index          = 0
    network_interface_id  = aws_network_interface.vpn_nic0.id
    delete_on_termination = false
  }

  #workaround for destroying ec2
  lifecycle {
    ignore_changes = [network_interface]
  }

  tags = merge(tomap({
    Name = "${var.env_type}-vpn01",
    type = "service" }),
    local.sec_tags
  )

}

resource "aws_route53_record" "vpn-host" {
  zone_id = aws_route53_zone.external.zone_id
  name    = "${var.env_type}-vpn01.${aws_route53_zone.external.name}"
  ttl     = 300
  type    = "A"
  records = [aws_eip.vpn_eip.public_ip]
}

resource "aws_route53_record" "vpn-service" {
  zone_id = aws_route53_zone.external.zone_id
  name    = "vpn.${aws_route53_zone.external.name}"
  ttl     = 300
  type    = "A"
  records = [aws_eip.vpn_eip.public_ip]
}
