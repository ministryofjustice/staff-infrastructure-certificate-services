output "public_ip" {
  value = module.ec2.public_ip
}

output "private_ip" {
  value = module.ec2.private_ip
}

output "instance_id" {
  value = module.ec2.id
}

output "password_data" {
  value = module.ec2.password_data
}
