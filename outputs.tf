# Pre prod
output "pre_prod_private_key_pem_format" {
  value = module.baseline_test_pre_production.private_key_pem_format
}

output "pre_prod_ec2_ca_gw_ip" {
  value = module.baseline_test_pre_production.ec2_ca_gw_ip
}

output "pre_prod_ec2_bastion_eip" {
  value = module.baseline_test_pre_production.ec2_bastion_eip
}

# Prod
output "prod_private_key_pem_format" {
  value = module.baseline_test_production.private_key_pem_format
}

output "prod_ec2_ca_gw_ip" {
  value = module.baseline_test_production.ec2_ca_gw_ip
}

output "prod_ec2_bastion_eip" {
  value = module.baseline_test_production.ec2_bastion_eip
}
