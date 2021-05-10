output "assume_role_arn" {
  value = aws_iam_role.mojo_prod_cloudwatch_exporter_assume_role.arn
}