output "private_key_pem_format" {
  value = module.test_key_pair.private_key_pem_format
}

# output "public_certificate_authority_gateway_ip" {
#   value = module.public_certificate_authority_gateway.public_ip
# }

output "public_registration_authority_front_end_ip" {
  value = module.public_registration_authority_front_end.public_ip
}

output "public_bastion_host_windows_ip" {
  value = module.public_bastion_host_windows.public_ip
}
