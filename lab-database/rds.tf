module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "demodb"

  engine            = "postgres"
  port              = 5432
  db_name           = "replicaPostgresql"
  username          = "replica_postgresql"
  password          = "UberSecretPassword"
  engine_version    = "13.13"
  instance_class    = "db.t4g.micro"
  allocated_storage = 5
  vpc_security_group_ids = [module.db_security_group.security_group_id]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.database_subnets

  # Enable automated backups
  backup_retention_period = 1

  manage_master_user_password = false

  # DB parameter group
  family = "postgres13"
}

# Create a Read Replica
module "db_read_replica" {
  source = "terraform-aws-modules/rds/aws"

  identifier                = "demodbreadreplica"
  engine                    = "postgres"
  instance_class            = "db.t4g.micro"
  publicly_accessible       = false
  # To Promote this to primary removing the replicants source db
  # replicate_source_db       = module.db.db_instance_identifier  # Reference the primary DB instance

  # Pass the family parameter
  family                    = "postgres13"
  # Security group and subnet
  vpc_security_group_ids = [module.db_security_group.security_group_id]

  # Tags for the replica
  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
output "rds_db" {
  value = module.db.db_instance_address
}
output "rds_read_replica" {
  value = module.db_read_replica.db_instance_address
}