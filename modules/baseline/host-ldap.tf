module "sg_ldap" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-ldap-security-group"

  ingress_with_cidr_blocks = [
    {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0" // TODO: We should limit this to CA GW and Issuing CA only
    },
  ]

  egress_with_cidr_blocks = []

  tags = var.tags
}

module "ec2_ldap" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.pki_vpc.private_subnet_backend_zone_id
  # private_ip             = local.ip_ldap
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_ldap.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-ldap"

  tags = var.tags
}
