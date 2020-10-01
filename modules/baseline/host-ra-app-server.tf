module "sg_ra_back_end" {
  source = ".././sg"

  vpc_id = module.pki_vpc.vpc_id

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

  prefix = var.prefix
  tags   = var.tags
}

module "ec2_ra_back_end" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.pki_vpc.private_subnets[1]
  # private_ip             = local.ip_ra_back_end
  key_name                    = module.test_key_pair.key_name
  vpc_security_group_ids      = [module.sg_ra_back_end.this_security_group_id]
  associate_public_ip_address = false

  name = "${var.prefix}-ra-back-end"
  tags = var.tags
}
