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

resource "aws_instance" "frontend_server" {
  depends_on = [ module.vpc.public_internet_gateway ]
  ami           = "ami-0d53d72369335a9d6" # Ubuntu 22.04 free tier ami in us-west-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name

  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.frontend_security_group.security_group_id]

}

resource "aws_instance" "backend_server" {
  availability_zone = "us-west-1a"
  private_ip = "172.16.101.10"
  ami                    = "ami-0d53d72369335a9d6" # Ubuntu 22.04 free tier ami in us-west-1
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [module.backend_security_group.security_group_id]
  user_data = file("${path.module}/install_backend.sh")

}

output "public_instance_public_ip" {
  value = aws_instance.frontend_server.public_ip
}
