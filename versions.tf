terraform {
  required_version = "1.4.6"

  required_providers {
    aws = {
      version = "~> 4.0"
    }
    archive = ">= 1.2.2"
  }
}
