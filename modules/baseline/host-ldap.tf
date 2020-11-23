module "sg_ldap" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-ldap-security-group"

  ingress_with_cidr_blocks = [
    # Bastion
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow SSH from the bastion host"
      cidr_blocks = local.cidr_bastion_host
    },

    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for bastion server"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },

   # VPC Traffic  
    {
      ##TO-CLEAR-UP
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "#TO-CLEAR-UP# Permit all ingress traffic from VPC"
      cidr_blocks = local.cidr_block_vpc
    },
  ]

  egress_with_cidr_blocks = [
    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for bastion server"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      ##TO-CLEAR-UP
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "#TO-CLEAR-UP# Permit all egress traffic"
      cidr_blocks = local.public_internet_cidr_block
    },
  ]

  tags = var.tags
}

module "ec2_ldap" {
  source = ".././ec2"

  ami                         = local.ami_rhel_7_6_x64
  instance_type               = local.instance_type_linux
  subnet_id                   = module.pki_vpc.private_subnet_backend_zone_id
  private_ip                  = local.ip_ldap
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_ldap.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-ldap"

  tags = merge(
    var.tags,
    {
      Environment = var.environment_description
    },
  )
}
