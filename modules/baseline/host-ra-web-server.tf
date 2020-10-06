module "sg_ra_web_server" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-ra-web-server-security-group"

  # Bastion
  ingress_with_cidr_blocks = [
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow SSH from the bastion host"
      cidr_blocks = local.cidr_bastion_host
    },

    # RA app server
    {
      from_port   = 8010
      to_port     = 8010
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 8013
      to_port     = 8013
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 9030
      to_port     = 9030
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },

    # Reverse proxy
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to reverse proxy"
      cidr_blocks = local.cidr_reverse_proxy
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
  ]

  egress_with_cidr_blocks = [
    # RA app server
    {
      from_port   = 8010
      to_port     = 8010
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 8013
      to_port     = 8013
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 9030
      to_port     = 9030
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },

    # Reverse proxy
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to reverse proxy"
      cidr_blocks = local.cidr_reverse_proxy
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
  ]

  tags = var.tags
}

module "ec2_ra_web_server" {
  source = ".././ec2"

  ami                         = local.ami_rhel_7_6_x64
  instance_type               = local.instance_type_linux
  subnet_id                   = module.pki_vpc.private_subnet_private_ra_zone_id
  private_ip                  = local.ip_ra_web_server
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_ra_web_server.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-ra-web-server"

  tags = var.tags
}
