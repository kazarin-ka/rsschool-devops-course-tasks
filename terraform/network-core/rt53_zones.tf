resource "aws_route53_zone" "external" {
  provider = aws.default
  comment  = var.default_description
  name     = var.dns_zone_external

  tags = merge(local.infra_tags,
    tomap({ Name = "${var.env_type}-external",
  type = "network" }))
}
