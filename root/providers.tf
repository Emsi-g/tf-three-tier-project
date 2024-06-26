terraform {
  required_providers {
    aws = {
        source                      = "hashicorp/aws"
        configuration_aliases       = [ aws.acm, aws.route53_acc ]
    }
  }
}

provider "aws" {
    region                          = "ap-southeast-1"
}

provider "aws" {
    alias                           = "acm"
    region                          = "us-east-1"
}

provider "aws" {
    alias                           = "route53_acc"
    region                          = "ap-southeast-1"
    assume_role {
        role_arn                    = "arn:aws:iam::<AWS Account ID for Another Account>:role/mc-tf-assumerole"  
    }
}