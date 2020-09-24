output "this_security_group_id" {
  description = "The ID of the security group"
  value = module.ssh_security_group.this_security_group_id
}