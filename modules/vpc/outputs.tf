output "vpc_id" {
  value = aws_vpc.pki_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_backend_zone_id" {
  value = aws_subnet.private_subnet_backend_zone.id
}

output "private_subnet_private_ra_zone_id" {
  value = aws_subnet.private_subnet_private_ra_zone.id
}
