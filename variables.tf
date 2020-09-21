variable "owner_email" {
  type = string
}

variable "assume_role" {
  type = string
}

variable "env" {
  type    = string
  default = "development"
}

variable "logging_cidr_block" {
  type        = string
  description = "the block to uses in the logging vpc" // WARNING! changing this in a applied workspace will cause an error! https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/467""
}
