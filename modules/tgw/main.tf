resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-attach-pki-prod-mojo" {
  tags = {
    "Name" = "attachment-${var.prefix}-tgw-mojo"
  }
  subnet_ids         = [var.private_subnet_private_ra_zone_id]
  transit_gateway_id = var.mojo_tgw_id
  vpc_id             = var.vpc_id
}