module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"
  name    = "${var.prefix}-security-group"
  vpc_id  = var.vpc_id
  tags    = var.tags

  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  egress_with_cidr_blocks  = var.egress_with_cidr_blocks
}
