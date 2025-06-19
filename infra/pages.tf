resource "cloudflare_pages_project" "frontend" {
  name       = "ragdoll-frontend"
  account_id = var.cloudflare_account_id
  production_branch = "main"
}

resource "cloudflare_pages_domain" "frontend_domain" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.frontend.name
  domain       = "ragdoll.tarinyoom.io"
}

output "frontend_project_url" {
  value = "https://${cloudflare_pages_domain.frontend_domain.domain}"
}
