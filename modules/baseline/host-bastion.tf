module "sg_bastion_host" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-bastion-host-security-group"

  ingress_with_cidr_blocks = [
    {
      from_port   = local.rdp_port
      to_port     = local.rdp_port
      protocol    = local.tcp_protocol
      description = "Remote desktop connections from the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow the bastion server to SSH into the reverse proxy"
      cidr_blocks = local.cidr_reverse_proxy
    },
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow the bastion server to SSH into the issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow the bastion server to SSH into the LDAP server"
      cidr_blocks = local.cidr_ldap
    },
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow the bastion server to SSH into the RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow the bastion server to SSH into the CA gateway"
      cidr_blocks = local.cidr_ca_gateway
    },
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow the bastion server to SSH into the RA web server"
      cidr_blocks = local.cidr_ra_web_server
    },
  ]

  tags = var.tags
}

module "ec2_bastion_host" {
  source = ".././ec2"

  ami                         = local.ami_windows_2019_x64
  instance_type               = "t2.micro"
  subnet_id                   = module.pki_vpc.public_subnet_id
  private_ip                  = local.ip_bastion_host
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_bastion_host.this_security_group_id]
  associate_public_ip_address = true
  get_password_data           = true
  server_description          = "${var.prefix}-bastion-host"

  tags = var.tags
}