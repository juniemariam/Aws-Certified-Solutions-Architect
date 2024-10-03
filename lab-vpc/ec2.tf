resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key"
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > ${path.module}/key.pem && chmod 0700 ${path.module}/key.pem"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = "ami-0d53d72369335a9d6" # Ubuntu 22.04 free tier ami in us-west-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
  subnet_id     = module.vpc.public_subnets[0]


  security_groups = [aws_security_group.allow_ssh_http.id]

  #user_data = file("${path.module}/install_apache.sh")

}
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion_host.id
  domain   = "vpc"
}

output "instance" {
  value = aws_eip.bastion_eip.public_ip
}

# Create an EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami                    = "ami-0d53d72369335a9d6" 
  instance_type          = "t2.micro"              
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id              = module.vpc.private_subnets[0] 
  vpc_security_group_ids = [aws_security_group.icmp_access.id, aws_security_group.ssh_access.id]

}

# Output the private IP address
output "private_ip" {
  value = aws_instance.private_instance.private_ip
}
