output "pre_prod_private_key_pem_format" {
  value = module.baseline_test_pre_production.private_key_pem_format
}

output "prod_private_key_pem_format" {
  value = module.baseline_test_production.private_key_pem_format
}

output "pre_prod_public_ec2_ca_gw_ip" {
  value = module.baseline_test_pre_production.ec2_ca_gw_ip
}

output "prod_public_ec2_ca_gw_ip" {
  value = module.baseline_test_production.ec2_ca_gw_ip
}

