variable "root_domain" {
  type        = string
  description = "Domain For ALB"
}

variable "tags" {
  type = map(string)
}
