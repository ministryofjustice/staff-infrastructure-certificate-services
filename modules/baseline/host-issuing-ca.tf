module "sg_issuing_ca" {
  source = ".././sg"

  vpc_id = module.pki_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 1443
      to_port     = 1443
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 709
      to_port     = 710
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 829
      to_port     = 829
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  prefix = var.prefix
  tags   = var.tags
}

module "ec2_issuing_ca" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.pki_vpc.private_subnets[1]
  # private_ip             = local.ip_issuing_ca
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_issuing_ca.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-issuing-ca"

  tags = var.tags
}
