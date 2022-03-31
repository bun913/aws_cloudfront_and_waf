variable "vpc_cidr" {
  type        = string
  description = "VPCiderBlocks"
}
variable "tags" {
  type        = map(any)
  description = "DeafaultTags for this project"
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
