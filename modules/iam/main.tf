terraform {
  required_providers {
    aws = {}
  }
}

resource "aws_iam_role" "mojo_prod_cloudwatch_exporter_assume_role" {
  name        = "mojo-prod-cloudwatch-exporter-prod-assume-role"
  description = "Allows the MoJO production root account access to Cloudwatch metrics in PKI Preprod and Prod"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "arn:aws:iam::${var.mojo_production_account_id}:root" }
    }]
  })
}

resource "aws_iam_policy" "mojo_prod_cloudwatch_access_policy" {
  name = "mojo_prod_cloudwatch_access_policy"

  policy = templatefile("${path.module}/policies/cloudwatch_access_policy.template.json", {})
}

resource "aws_iam_role_policy_attachment" "mojo_prod_cloudwatch_access_policy_attachment" {
  role       = aws_iam_role.mojo_prod_cloudwatch_exporter_assume_role.name
  policy_arn = aws_iam_policy.mojo_prod_cloudwatch_access_policy.arn
}