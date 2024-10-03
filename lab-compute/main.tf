terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region  = "us-west-1"
}

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

resource "aws_instance" "app_server" {
  ami           = "ami-0d53d72369335a9d6"  # Ubuntu 22.04 free tier ami in us-west-1
  instance_type = "t2.nano"
  key_name = aws_key_pair.key_pair.key_name

  
  security_groups = [aws_security_group.allow_ssh_http.name]

   user_data = file("${path.module}/install_apache.sh")

}

output "instance" {
  value = aws_instance.app_server.public_ip
}
