module "s3_bucket_test" {
  source = ".././test"

  prefix      = var.prefix
  environment = var.environment
  tags        = var.tags
}
