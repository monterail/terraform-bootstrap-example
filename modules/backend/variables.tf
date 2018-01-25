variable "bootstrap" {
  description = "Whether bootstrap basic infra or not"
}

variable "operators" {
  description = "List of AWS usernames with access to Terraform state bucket"
  type        = "list"
}
