module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "172.16.0.0/16"


  azs              = ["us-west-1a", "us-west-1c"]
  private_subnets  = ["172.16.101.0/24", "172.16.201.0/24"]
  public_subnets   = ["172.16.102.0/24", "172.16.202.0/24"]
  database_subnets = ["172.16.103.0/24", "172.16.203.0/24"]

  create_database_subnet_group = true

  map_public_ip_on_launch = true

  create_igw = true

  enable_nat_gateway = true
}


output "vpc-id" {
  value = module.vpc.vpc_id
}


