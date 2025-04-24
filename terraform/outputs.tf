# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

output "worker_group_mgmt_one_sg_id" {
  description = "The ID of the worker_group_mgmt_one security group"
  value       = aws_security_group.worker_group_mgmt_one.id
}

output "worker_group_mgmt_two_sg_id" {
  description = "The ID of the worker_group_mgmt_two security group"
  value       = aws_security_group.worker_group_mgmt_two.id
}

output "all_worker_mgmt_sg_id" {
  description = "The ID of the all_worker_mgmt security group"
  value       = aws_security_group.all_worker_mgmt.id
}