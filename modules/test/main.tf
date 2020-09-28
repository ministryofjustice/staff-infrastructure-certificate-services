resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.prefix}-test-bucket"
  acl    = "private"
  tags   = var.tags
}

