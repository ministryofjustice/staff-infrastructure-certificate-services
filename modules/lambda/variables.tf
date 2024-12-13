variable "function_name" {
  description = "Name of the Lambda function."
  type        = string
}

variable "description" {
  description = "Description of the lambda."
  type        = string
}

variable "source_dir" {
  description = "Location of the lambda function code."
  type        = string
}

variable "output_path" {
  description = "Output destination for the zipped lambda function."
  type        = string
}

variable "ms_teams_webhook_url" {
  description = "MS Teams webhook URL to send alarm to."
  type        = string
}
