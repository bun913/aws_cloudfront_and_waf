terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.8.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

locals {
  default_prefix = var.tags.Project
}

module "ecr" {
  source = "./modules/ecr"

  prefix = local.default_prefix
  tags   = var.tags
}

module "route53" {
  source = "./modules/route53"

  root_domain = var.root_domain
  tags        = var.tags
}
