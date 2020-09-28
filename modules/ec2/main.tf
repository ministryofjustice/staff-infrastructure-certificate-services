module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name                   = var.prefix         // TODO: name these properly
  instance_count         = var.instance_count // TODO: remove
  user_data              = var.user_data
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  tags = var.tags
}
