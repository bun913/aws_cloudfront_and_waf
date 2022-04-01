provider "aws" {
  region = var.region
  default_tags {
    tags = {
      "Project"     = var.tags.Project
      "Environment" = var.tags.Environment
      "Terraform"   = var.tags.Terraform
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  ecr_repo_uri = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.tags.Project}-app"
}

module "network" {
  source          = "./modules/network/"
  vpc_cidr        = var.vpc.cidr_block
  private_subnets = var.private_subnets
  alb_subnets     = var.alb_subnets

  tags = var.tags
}

module "cert" {
  source = "./modules/cert/"

  root_domain  = var.root_domain
  host_zone_id = var.host_zone_id
}

/* module "web_app" { */
/*   source = "./modules/web_app/" */

/*   project     = var.project */
/*   alb_name    = "${var.project}-internal-lb" */
/*   vpc_id      = module.network.vpc_id */
/*   alb_subnets = module.network.alb_subnet_ids */

/*   vpc_cidr               = var.vpc.cidr_block */
/*   private_subnets        = module.network.private_subnet_ids */
/*   private_route_table_id = module.network.private_route_table_id */
/*   interface_services     = var.vpc_endpoint.interface */
/*   gateway_services       = var.vpc_endpoint.gateway */

/*   region = var.region */

/*   tags = var.tags */
/* } */
