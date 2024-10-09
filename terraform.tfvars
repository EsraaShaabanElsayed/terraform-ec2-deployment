region          = "us-east-1"
vpc_name        = "second-vpc"
vpc_cidr        = "10.0.0.0/16"
azs             = ["us-east-1a"]
private_subnets = ["10.0.128.0/20"]
public_subnets  = ["10.0.0.0/20"]
ami             = "ami-0866a3c8686eaeeba"
instance_type   = "t2.micro"
instance_tag    = "ec2-instance"