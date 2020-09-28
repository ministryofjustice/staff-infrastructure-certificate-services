output "public_certificate_authority_gateway_ip" {
  value = module.public_certificate_authority_gateway.public_ip
}

output "private_key_pem_format" {
  value = module.test_key_pair.private_key_pem_format
}
