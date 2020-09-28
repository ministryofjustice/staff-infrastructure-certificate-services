resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.prefix}-DELETE-ME-PKI"
  acl    = "private"
  tags   = var.tags
}

