terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "kennethsvbucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mi-tabla-dynamodb"
    encrypt        = true
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region = var.aws_region  # Región que se utilizará para crear recursos en AWS.
}

