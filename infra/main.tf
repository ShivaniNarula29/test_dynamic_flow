provider "aws" {
  region = var.region
}

resource "aws_security_group" "prometheus_sg" {
  name   = "prometheus-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public" {
  ami             = var.prometheus_ami
  instance_type   = var.instance_type
  subnet_id       = var.public_subnet_id
  key_name        = var.key_name
  security_groups = [aws_security_group.prometheus_sg.name]

  tags = {
    Name = "prometheus-public"
    Role = "prometheus"
  }
}

resource "aws_instance" "private" {
  ami             = var.prometheus_ami
  instance_type   = var.instance_type
  subnet_id       = var.private_subnet_id
  key_name        = var.key_name
  security_groups = [aws_security_group.prometheus_sg.name]

  tags = {
    Name = "prometheus-private"
    Role = "prometheus"
  }
}

output "public_ips" {
  value = aws_instance.public.public_ip
}

output "private_ips" {
  value = aws_instance.private.private_ip
}
