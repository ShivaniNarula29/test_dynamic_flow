variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {}

variable "public_subnet_id" {}
variable "private_subnet_id" {}

variable "key_name" {}
variable "instance_type" {
  default = "t3.micro"
}

variable "prometheus_ami" {}
