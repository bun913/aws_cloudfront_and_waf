variable "prefix" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "alb_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "ecr_base_uri" {
  type        = string
  description = "globalで作成したECRのリポジトリのベースURL"
}
variable "tags" {
  type        = map(any)
  description = "DeafaultTags for this project"
}

variable "interface_services" {
  type        = list(string)
  description = "Service_names for interface vpc endpoint"
}

variable "gateway_services" {
  type        = list(string)
  description = "Service_names for gateway vpc endpoint"
}

variable "private_route_table_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "region" {
  type = string
}

variable "root_domain" {
  type        = string
  description = "RootDomain"
}

variable "host_zone_id" {
  type        = string
  description = "global配下で作成したRoute53のホストゾーンID"
  sensitive   = true
}

variable "acm_arn" {
  type        = string
  description = "ALB用のACMのARN"
}
