module "security_group" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "~> 3.0"
  name                     = var.security_group_description
  vpc_id                   = var.vpc_id
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks

  tags = merge(
    var.tags,
    {
      Name = var.security_group_description
    },
  )
}
