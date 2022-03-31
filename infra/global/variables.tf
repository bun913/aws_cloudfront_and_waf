variable "tags" {
  default = {
    "Terraform" = "true",
    "Project"   = "sample"
  }
  type = map(string)
}
variable "root_domain" {
  type      = string
  sensitive = true
}
