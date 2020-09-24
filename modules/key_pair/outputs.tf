output "public_key" {
  value = tls_private_key.this.public_key_openssh
}

output "key_pair_name" {
  value = module.key_pair.this_key_pair_key_name
}
