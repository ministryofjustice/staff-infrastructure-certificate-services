module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name                   = var.server_description
  user_data              = var.user_data
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  private_ip             = var.private_ip

  associate_public_ip_address = var.associate_public_ip_address

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  get_password_data = var.get_password_data

  root_block_device = var.root_block_device

  tags = merge(
    var.tags,
    {
      Name           = var.server_description
      scheduledStop  = var.scheduledStop
      scheduledStart = var.scheduledStart
    },
  )
}
