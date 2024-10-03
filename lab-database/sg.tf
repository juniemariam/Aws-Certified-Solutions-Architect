module "frontend_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "frontend sg"
  description = "Replica PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP Access from internet"
      cidr_blocks = "0.0.0.0/0"
    },    
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH Access from internet"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      description = "SSH Access from internet"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  # egress

  egress_with_cidr_blocks = [  
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      description = "All egress internet access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "backend_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "backend sg"
  description = "Replica PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_source_security_group_id = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP Access from frontend server"
      source_security_group_id = module.frontend_security_group.security_group_id
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH Access from frontend server"
      source_security_group_id = module.frontend_security_group.security_group_id
    },
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "SSH Access from frontend server"
      source_security_group_id = module.db_security_group.security_group_id
    }
  ]

  egress_with_cidr_blocks = [  
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      description = "All egress internet access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

}


module "db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "db sg"
  description = "Replica PostgreSQL example security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {

      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

}