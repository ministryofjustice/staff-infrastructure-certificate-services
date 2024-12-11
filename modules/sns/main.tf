module "sns" {
  source  = "terraform-aws-modules/sns/aws"
  version = "~> 3.0"

  name = var.name
}
