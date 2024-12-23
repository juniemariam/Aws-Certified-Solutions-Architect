# Define the security group
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-security-group"

  # Inbound rules
  ingress {
    from_port   = 22           # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from any IP (you can restrict it to a specific IP)
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"         # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MyEC2SecurityGroup"
  }
}

# Attach the security group to the EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-0d53d72369335a9d6"
  instance_type = "t2.micro"
  key_name      = "my_key"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_access.name
  associate_public_ip_address = true

  tags = {
    Name = "MyEC2Instance"
  }
}

output "ec2_private_ip" {
  value = aws_instance.my_ec2.private_ip
}
output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}
