module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name                   = var.name
  user_data              = var.user_data
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  private_ip             = var.private_ip

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  get_password_data = var.get_password_data

  tags = var.tags
}
