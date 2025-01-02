# resource "aws_dynamodb_table" "users_table" {
#   name         = "users"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "user_id"
#
#   attribute {
#     name = "user_id"
#     type = "S"
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }
#
# resource "aws_dynamodb_table" "products_table" {
#   name         = "products"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "product_id"
#
#   attribute {
#     name = "product_id"
#     type = "S"
#   }
#
#   tags = {
#     Environment = "production"
#   }
# }


resource "aws_db_instance" "ecommerce_rds" {
  identifier          = "ecommerce-db-instance"
  engine              = "mysql"
  engine_version      = "8.0"  # You can adjust the version as needed
  instance_class      = "db.t3.micro"  # Choose instance class based on needs
  allocated_storage   = 20  # Specify storage size in GB
  db_name             = "ecommerce_db"
  username            = "admin"  # Replace with a secure username
  password            = var.password  # Replace with a secure password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.ecommerce_db_subnet_group.name
  multi_az            = false
  publicly_accessible = false  # Set to true if needed, false is recommended for private access
  storage_encrypted   = true
  skip_final_snapshot = true
  tags = {
    Environment = "production"
  }
}

# Define the DB Subnet Group to specify subnets for RDS
resource "aws_db_subnet_group" "ecommerce_db_subnet_group" {
  name       = "ecommerce-db-subnet-group"
  subnet_ids = [
    aws_subnet.public_subnet.id,
    aws_subnet.public_subnet_3.id
  ]
  tags = {
    Name = "ecommerce-db-subnet-group"
  }
}
