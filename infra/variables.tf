variable "cloudflare_account_id" {
  description = "Your Cloudflare account ID"
  type        = string
}

variable "cloudflare_api_token" {
  description = "API token for managing Pages and DNS"
  type        = string
  sensitive   = true
}
