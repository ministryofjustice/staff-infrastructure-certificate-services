module "sg_ca_gateway" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-ca-gateway-security-group"

  # Bastion
  ingress_with_cidr_blocks = [
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow SSH from the bastion host"
      cidr_blocks = local.cidr_bastion_host
    },

    # Issuing CA
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },

    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for CA gateway"
      cidr_blocks = local.cidr_ldap
    },
  ]

  egress_with_cidr_blocks = [
    # Issuing CA
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow CA gateway to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },

    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for CA gateway"
      cidr_blocks = local.cidr_ldap
    },
  ]

  tags = var.tags
}

module "ec2_ca_gateway" {
  source = ".././ec2"

  ami                         = local.ami_rhel_7_6_x64
  instance_type               = "t2.micro"
  subnet_id                   = module.pki_vpc.private_subnet_backend_zone_id
  private_ip                  = local.ip_ca_gateway
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_ca_gateway.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-ca-gateway"

  tags = var.tags
}