module "ec2_bastion_host" {
  source = ".././ec2"

  ami           = local.ami_windows_2019_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.public_subnets[0]
  # private_ip             = local.ip_bastion_host
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_bastion_host.this_security_group_id]
  get_password_data      = true

  name = "${var.prefix}-bastion-host"
  tags = var.tags
}

resource "aws_eip" "ec2_bastion_eip" {
  instance = module.ec2_bastion_host.instance_id[0]
  vpc      = true
}

module "sg_bastion_host" {
  source = ".././sg"

  vpc_id = module.test_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = "Remote desktop from the public Internet"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = []

  prefix = var.prefix
  tags   = var.tags
}
