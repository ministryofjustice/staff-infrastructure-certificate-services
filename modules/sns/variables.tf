variable "name" {
  description = "The name for the SNS Topic."
  type        = string
}

variable "teams_webhook_url" {
  description = "The MS Teams Channel Webhook url to send the message card too."
  type        = string
}
