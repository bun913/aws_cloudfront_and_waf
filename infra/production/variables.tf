variable "region" {
  type    = string
  default = "ap-northeast-1"
}
variable "tags" {
  default = {
    "Terraform"   = "true"
    "Environment" = "prd"
    "Project"     = "sample"
  }
  type = map(string)
}

variable "vpc" {
  type        = map(string)
  description = "VPCSettings from tfvars"
}

variable "private_subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
  description = "Private Subnet Settings"
}

variable "alb_subnets" {
  type = list(object({
    name       = string
    cidr_block = string
    az         = string
  }))
  description = "alb Subnet Settings"
}

variable "vpc_endpoint" {
  type        = map(any)
  description = "vpc_endpoint_setting"
}

variable "host_zone_id" {
  type        = string
  description = "globalで作成したRoute53のホストゾーンID"
  sensitive   = true
}

variable "root_domain" {
  type        = string
  description = "RootDomain"
  sensitive   = true
}
