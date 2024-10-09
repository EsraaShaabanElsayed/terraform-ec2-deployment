variable "vpc_name" {
  type        = string
  description = "this is the name of the vpc "
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  type        = list(string)
  description = "This is the list of availabilty zones "
}

variable "private_subnets" {
  type        = list(string)
  description = "The prive subnets ClDR Blocks"
}

variable "public_subnets" {
  type        = list(string)
  description = "The public subnets  ClDR Blocks"

}

variable "region" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_tag" {
  type        = string
  description = "the tag of the instance "
}

variable "instance_type" {
  type        = string
  description = "the type of the ec2 "

}
