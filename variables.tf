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
