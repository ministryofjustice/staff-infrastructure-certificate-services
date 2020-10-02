# Pre prod
output "pre_prod_private_key_pem_format" {
  value = module.baseline_pre_production.private_key_pem_format
}

output "pre_prod_ec2_ca_gateway_public_ip" {
  value = module.baseline_pre_production.ca_gateway_public_ip
}

output "pre_prod_ec2_bastion_public_ip" {
  value = module.baseline_pre_production.ec2_bastion_public_ip
}

output "pre_prod_ec2_bastion_password_data" {
  value = module.baseline_pre_production.ec2_bastion_password_data
}

# Prod
output "prod_private_key_pem_format" {
  value = module.baseline_production.private_key_pem_format
}

output "prod_ca_gateway_public_ip" {
  value = module.baseline_production.ca_gateway_public_ip
}

output "prod_ec2_bastion_public_ip" {
  value = module.baseline_production.ec2_bastion_public_ip
}

output "prod_ec2_bastion_password_data" {
  value = module.baseline_production.ec2_bastion_password_data
}
