module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.13.0"
  name            = var.vpc_name
  cidr            = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

}

# module "ssh_security_group" {
#     source  = "terraform-aws-modules/security-group/aws//modules/ssh"
#     version = "~> 5.0"
#     name    = "web-server"
#     description = "Security group for web-server with HTTP ports open within VPC"
#     vpc_id      = vpc_Id
# }
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH traffic"
  vpc_id      = module.vpc.vpc_id # Updated to use module output

  tags = {
    Name = "allow_ssh"
  }
}



resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {

  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0" # This allows SSH from any IPv4 address (for tighter security, replace with a specific IP range)
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv6" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv6         = "::/0" # Allows SSH from any IPv6 address (you can tighten this if needed)
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# resource "tls_private_key" "private_key" {
#     algorithm = "ECDSA"
# }



resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits = 2048
}

resource "local_sensitive_file" "private-key-file" {
  content         = tls_private_key.private_key.private_key_pem
  filename        = "private-key-file.pem"
  file_permission = "0400"
}

resource "aws_key_pair" "instance-key" {
  key_name   = "instance-key"
  public_key = tls_private_key.private_key.public_key_openssh
  
}

resource "aws_instance" "ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = aws_key_pair.instance-key.key_name
  tags = {
    Name = var.instance_tag
  }

}