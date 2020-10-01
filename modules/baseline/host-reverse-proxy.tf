module "sg_reverse_proxy" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-reverse-proxy-security-group"

  ingress_with_cidr_blocks = []

  egress_with_cidr_blocks = []

  tags = var.tags
}

module "ec2_reverse_proxy" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.pki_vpc.public_subnets[0]
  # private_ip             = local.ip_reverse_proxy
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_reverse_proxy.this_security_group_id]
  associate_public_ip_address = true
  get_password_data           = false
  server_description          = "${var.prefix}-reverse-proxy"

  tags = var.tags
}
