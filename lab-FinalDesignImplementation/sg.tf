# resource "aws_security_group" "frontend_sg" {
#   name        = "frontend-lb-sg"
#   vpc_id      = aws_vpc.ecommerce_vpc.id
#
#   ingress {
#     description = "Allow HTTP traffic"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
#   }
#
#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "frontend-lb-sg"
#   }
# }

# resource "aws_security_group" "backend_sg" {
#   name        = "backend-lb-sg"
#   vpc_id      = aws_vpc.ecommerce_vpc.id
#
#   ingress {
#     description = "Allow HTTP traffic"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
#   }
#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name = "backend-lb-sg"
#   }
# }

# resource "aws_security_group_rule" "backend_ingress" {
#   type                     = "ingress"
#   from_port                = 3000
#   to_port                  = 3000
#   protocol                 = "tcp"
#   security_group_id        = aws_security_group.backend_sg.id
#   source_security_group_id = aws_security_group.frontend_sg.id  # Allow traffic only from frontend SG
# }

# Define the security group for RDS
resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.ecommerce_vpc.id

  ingress {
    description = "Allow MySQL traffic from backend"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = []  # No CIDR block, use security group for controlled access
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# Define the rule to allow inbound traffic from backend security group
resource "aws_security_group_rule" "rds_backend_ingress" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.backend_sg.id  # Allow traffic only from backend SG
}

# Define the backend security group (for example, for backend load balancer)
resource "aws_security_group" "backend_sg" {
  name   = "backend-lb-sg"
  vpc_id = aws_vpc.ecommerce_vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic from anywhere
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-lb-sg"
  }
}
