locals {
  ec2_key_pair_name = "${var.prefix}-${var.key_name_suffix}"
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name   = local.ec2_key_pair_name
  public_key = tls_private_key.this.public_key_openssh
}
