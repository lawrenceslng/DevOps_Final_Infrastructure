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

output "qa_sg_id" {
  description = "The ID of the qa_ec2_group security group"
  value       = aws_security_group.qa_ec2_group.id
}

output "lb_sg_id" {
  description = "The ID of the load_balancer_sg security group"
  value       = aws_security_group.load_balancer_sg.id
}


output "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  value       = aws_route53_zone.main.zone_id
}

# Output RDS endpoint
output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.prod_db.endpoint
}

# Output Valkey endpoint
output "valkey_primary_endpoint" {
  description = "Primary Valkey endpoint"
  value       = aws_elasticache_replication_group.valkey.primary_endpoint_address
}