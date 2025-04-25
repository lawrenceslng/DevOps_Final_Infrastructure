# Subnet group for RDS (private subnets only)
resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

# RDS Instance
resource "aws_db_instance" "prod_db" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "root"
  password               = "password"  # <-- Better to pass as a sensitive variable
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name

  publicly_accessible    = false  # Private RDS
  multi_az               = false  # Single AZ (you can enable later if needed)
}

# Subnet group for ElastiCache (private subnets)
resource "aws_elasticache_subnet_group" "valkey_subnets" {
  name       = "redis-valkey-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

# ElastiCache Replication Group for Valkey
resource "aws_elasticache_replication_group" "valkey" {
  replication_group_id          = "valkey"
  description                   = "Valkey for var.project_name"
  engine                        = "valkey"
  engine_version                = "7.2"
  node_type                     = "cache.t3.micro"  # Small cheap node

  num_node_groups               = 1
  replicas_per_node_group       = 0  # Single node
  automatic_failover_enabled    = false
  multi_az_enabled              = false

  transit_encryption_enabled    = true
  at_rest_encryption_enabled    = true

  security_group_ids            = [aws_security_group.redis-valkey_sg.id]
  subnet_group_name             = aws_elasticache_subnet_group.valkey_subnets.name

}