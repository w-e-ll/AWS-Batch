output "vpi_id" {
  value = var.get_vpc ? data.aws_vpc.current_vpc[0].id : null
}

output "public_subnets" {
  value = var.get_vpc ? data.aws_subnet_ids.public_subnets[0].ids : null
}

output "private_subnets" {
  value = var.get_vpc ? data.aws_subnet_ids.private_subnets[0].ids : null
}
