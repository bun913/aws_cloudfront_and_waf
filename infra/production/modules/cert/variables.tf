variable "root_domain" {
  type        = string
  description = ""
}
variable "host_zone_id" {
  type        = string
  description = "global配下で作成したRoute53のホストゾーンID"
  sensitive   = true
}
