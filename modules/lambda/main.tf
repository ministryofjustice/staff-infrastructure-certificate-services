data "archive_file" "teams_lambda_file" {
  type        = "zip"
  source_dir  = var.source_file
  output_path = var.output_path
}

module "teams_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 3.0"

  function_name = var.function_name
  description   = var.description
  handler       = "index.lambda_handler"
  runtime       = "python3.9"

  create_package         = false
  local_existing_package = var.output_path

  # Set environment variables for the Lambda function
  environment_variables = {
    MS_TEAMS_WEBHOOK_URL = var.ms_teams_webhook_url
  }
}
