resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = {
    Name = "allow_ssh_http"
  }
}

 resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
   security_group_id = aws_security_group.allow_ssh_http.id
   from_port         = 80
   cidr_ipv4         = "0.0.0.0/0"
   ip_protocol       = "tcp"
   to_port           = 80
 }

 resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv6" {
   security_group_id = aws_security_group.allow_ssh_http.id
   from_port         = 80
   cidr_ipv6         = "::/0"
   ip_protocol       = "tcp"
   to_port           = 80
 }

# hmm, comment troll claims this piece of code.

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh_http.id
  from_port         = 22
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
  security_group_id = aws_security_group.allow_ssh_http.id
  from_port         = 22
  cidr_ipv6         = "::/0"
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_ssh_http.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
