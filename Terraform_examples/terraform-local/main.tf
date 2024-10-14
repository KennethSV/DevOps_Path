provider "aws" {
  region = "us-west-2"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}