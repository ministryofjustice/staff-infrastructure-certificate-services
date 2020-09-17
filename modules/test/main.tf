resource "aws_s3_bucket" "test_bucket" {
  bucket = "${var.prefix}-pki-test-bucket-x"
  acl    = "private"
}
