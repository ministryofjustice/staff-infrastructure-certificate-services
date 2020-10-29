variable "env" {
  type    = string
  default = "development"
}

variable "trusted_cidr" {
  type    = string
}


variable "customer_gateway_primary_ip" {
    type = string
}

variable "primary_remote_destination_cidr" {
    type = string
}

variable "primary_internal_cidr" {
    type = string
}

variable "customer_gateway_secondary_ip" {
    type = string
}

variable "secondary_remote_destination_cidr" {
    type = string
}

variable "seondary_internal_cidr" {
    type = string
}