variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "az1" {
  default = "us-west-1a"
}

variable "az2" {
  default = "us-west-1b"
}

variable "az3" {
  default = "us-west-1c"
}

variable "frontend_ami" {
  description = "AMI ID for the frontend EC2 instance"
  default     = "ami-0d53d72369335a9d6" # Example AMI for Ubuntu
}

variable "backend_ami" {
  description = "AMI ID for the backend EC2 instance"
  default     = "ami-0d53d72369335a9d6" # Example AMI for Ubuntu
}

variable "instance_type" {
  default = "t2.micro"
}

variable "domain_name" {
  default = "example.com" # Replace with your domain name
}

variable "notification_email" {
  default = "junie.mariamvarghese@sjsu.edu" # Replace with your email address
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-west-1" # Replace with your desired region
}

variable "key_name" {
  description = "The name of the key pair to be used for EC2 instances"
  default     = "final-key" # Replace with your actual key pair name
}

variable "use_load_balancer" {
  description = "Whether to use a load balancer for frontend instances"
  type        = bool
  default     = true # Set to true or false based on whether you want to use a load balancer
}

variable "password" {
  description = "password for db"
  default     = "HelloWorld" # Replace with your desired region
}
