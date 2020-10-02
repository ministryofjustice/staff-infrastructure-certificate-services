module "sg_ra_app_server" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-ra-app-server-security-group"

  ingress_with_cidr_blocks = [
    {
      from_port   = 9009
      to_port     = 9009
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9039
      to_port     = 9039
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8010
      to_port     = 8013
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = []

  tags = var.tags
}

module "ec2_ra_app_server" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.pki_vpc.private_subnet_backend_zone_id
  # private_ip             = local.ip_ra_app_server
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_ra_app_server.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-ra-app-server"

  tags = var.tags
}
