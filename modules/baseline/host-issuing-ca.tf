module "sg_issuing_ca" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-issuing-ca-security-group"

  ingress_with_cidr_blocks = [
    # Bastion
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow SSH from the bastion host"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },

    # RA app server
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },

    # CA gateway
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },

    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for issuing CA"
      cidr_blocks = local.cidr_ldap
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },

    # Inter VPC Traffic
    {
      ##TO-CLEAR-UP
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "#TO-CLEAR-UP# Permit all egress traffic"
      cidr_blocks = local.cidr_block_vpc
    },

    # HSM Primary
    {
      from_port   = 1792
      to_port     = 1792
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to HSM Primary"
      cidr_blocks = local.ip_hsm_primary
    },

    # HSM Secondary
    {
      from_port   = 1792
      to_port     = 1792
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to HSM Secondary"
      cidr_blocks = local.ip_hsm_secondary
    },
  ]

  egress_with_cidr_blocks = [
    # RA app server
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },

    # CA gateway
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },

    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow LDAP for issuing CA"
      cidr_blocks = local.cidr_ldap
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to access the public Internet"
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

    # Bastion
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to talk to bastion"
      cidr_blocks = local.cidr_bastion_host
    },

    # HSM Primary
    {
      from_port   = 1792
      to_port     = 1792
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to HSM Primary"
      cidr_blocks = local.ip_hsm_primary
    },
    # HSM Secondary
    {
      from_port   = 1792
      to_port     = 1792
      protocol    = local.tcp_protocol
      description = "Allow issuing CA to HSM Secondary"
      cidr_blocks = local.ip_hsm_secondary
    },

  ]

  tags = var.tags
}

module "ec2_issuing_ca" {
  source = ".././ec2"

  ami                         = local.ami_rhel_7_6_x64
  instance_type               = local.instance_type_linux
  subnet_id                   = module.pki_vpc.private_subnet_backend_zone_id
  private_ip                  = local.ip_issuing_ca
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_issuing_ca.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-issuing-ca"

  root_block_device = [
  {
    volume_size = 30
  },
  ]    

  tags = merge(
    var.tags,
    {
      Environment = var.environment_description
    },
  )
}
