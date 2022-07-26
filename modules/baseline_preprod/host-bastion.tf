module "sg_bastion_host" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-bastion-host-security-group"

  ingress_with_cidr_blocks = [
    # RDP
    {
      from_port   = local.rdp_port
      to_port     = local.rdp_port
      protocol    = local.tcp_protocol
      description = "Remote desktop connections from the public Internet"
      cidr_blocks = var.trusted_cidr
    },

    # Issuing CA
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },

    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to LDAP"
      cidr_blocks = local.cidr_ldap
    },
  ]

  egress_with_cidr_blocks = [
    {
      # SSH into all Linux instances
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

    # Egress to any public IP
    {
      from_port   = local.tcp_port_range_start
      to_port     = local.tcp_port_range_end
      protocol    = local.tcp_protocol
      description = "Allow all outbound connections from bastion to the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },

    # Issuing CA
    {
      from_port   = 443
      to_port     = 443
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 709
      to_port     = 709
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 710
      to_port     = 710
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },
    {
      from_port   = 829
      to_port     = 829
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to issuing CA"
      cidr_blocks = local.cidr_issuing_ca
    },

    # LDAP
    {
      from_port   = local.ldap_port
      to_port     = local.ldap_port
      protocol    = local.tcp_protocol
      description = "Allow bastion to talk to LDAP"
      cidr_blocks = local.cidr_ldap
    },
  ]

  tags = var.tags
}

module "ec2_bastion_host" {
  source = ".././ec2"

  ami                         = local.ami_windows_2019_x64
  instance_type               = local.instance_type_windows
  subnet_id                   = module.pki_vpc.public_subnet_id
  private_ip                  = local.ip_bastion_host
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_bastion_host.this_security_group_id]
  associate_public_ip_address = true
  get_password_data           = true
  server_description          = "${var.prefix}-bastion-host"

  root_block_device = [
    {
      volume_size = 100
    },
  ]

  tags = merge(
    var.tags,
    {
      Environment = var.environment_description
    },
  )
}

resource "aws_eip" "bastion_host_eip" {
  instance = module.ec2_bastion_host.instance_id[0]
  vpc      = true

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-bastion-host-eip"
    },
  )
}
