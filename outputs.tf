output "pre_prod_private_key_pem_format" {
  value = module.baseline_test_pre_production.private_key_pem_format
}

output "prod_private_key_pem_format" {
  value = module.baseline_test_production.private_key_pem_format
}

output "pre_prod_public_certificate_authority_gateway_ip" {
  value = module.baseline_test_pre_production.public_certificate_authority_gateway_ip
}

output "prod_public_certificate_authority_gateway_ip" {
  value = module.baseline_test_production.public_certificate_authority_gateway_ip
}

