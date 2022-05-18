module "sg_reverse_proxy" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-reverse-proxy-security-group"

  ingress_with_cidr_blocks = [
    # Bastion
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow SSH from the bastion host"
      cidr_blocks = local.cidr_bastion_host
    },

    # RA web server
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = local.tcp_protocol
      description = "Allow reverse proxy to talk to RA web server "
      cidr_blocks = local.cidr_ra_web_server
    },

    # CA gateway
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = local.tcp_protocol
      description = "Allow reverse proxy to talk to CA gateway "
      cidr_blocks = local.cidr_ca_gateway
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
      description = "Allow reverse proxy to access the public Internet"
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
  ]

  egress_with_cidr_blocks = [
    # RA web server
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = local.tcp_protocol
      description = "Allow reverse proxy to talk to RA web server "
      cidr_blocks = local.cidr_ra_web_server
    },

    # CA gateway
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = local.tcp_protocol
      description = "Allow reverse proxy to talk to CA gateway "
      cidr_blocks = local.cidr_ca_gateway
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
      description = "Allow reverse proxy to access the public Internet"
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

module "ec2_reverse_proxy" {
  source = ".././ec2"

  ami                         = local.ami_rhel_7_6_x64
  instance_type               = local.instance_type_linux
  subnet_id                   = module.pki_vpc.public_subnet_id
  private_ip                  = local.ip_reverse_proxy
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_reverse_proxy.this_security_group_id]
  associate_public_ip_address = true
  get_password_data           = false
  server_description          = "${var.prefix}-reverse-proxy"

  root_block_device = [
    {
      volume_size = 40
    },
  ]

  tags = merge(
    var.tags,
    {
      Environment = var.environment_description
    },
  )
}
