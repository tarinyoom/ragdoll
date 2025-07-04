variable "cloudflare_account_id" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type = string
}

variable "aws_region" {
  type = string
}
