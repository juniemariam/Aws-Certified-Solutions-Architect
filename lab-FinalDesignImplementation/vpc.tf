resource "aws_vpc" "ecommerce_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "ecommerce-vpc"
  }
}

# Existing Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.ecommerce_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.az1
  tags = {
    Name = "public-subnet"
  }
}

# Additional Public Subnet 1

# Additional Public Subnet 2
resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.ecommerce_vpc.id
  cidr_block        = "10.0.6.0/24"  # New CIDR block
  map_public_ip_on_launch = true
  availability_zone = var.az3
  tags = {
    Name = "public-subnet-3"
  }
}

# Existing Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.ecommerce_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.az1
  tags = {
    Name = "private-subnet"
  }
}

# Additional Private Subnet 1


# Additional Private Subnet 2
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.ecommerce_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = var.az3
  tags = {
    Name = "private-subnet-3"
  }
}

resource "aws_internet_gateway" "ecommerce_igw" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  tags = {
    Name = "ecommerce-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ecommerce_vpc.id
  tags = {
    Name = "public-route-table"
  }
}

# Add a default route for Internet Gateway
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ecommerce_igw.id
}

resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length([aws_subnet.public_subnet.id, aws_subnet.public_subnet_3.id])
  subnet_id      = element([aws_subnet.public_subnet.id, aws_subnet.public_subnet_3.id], count.index)
  route_table_id = aws_route_table.public_rt.id
}

