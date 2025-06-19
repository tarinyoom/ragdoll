resource "cloudflare_workers_script" "backend_worker" {
  name       = "ragdoll-backend"
  account_id = var.cloudflare_account_id

  content = file("${path.module}/../dist/worker/index.js")
  module  = true
}

resource "cloudflare_workers_route" "backend_route" {
  zone_id     = var.cloudflare_zone_id
  pattern     = "ragdoll.tarinyoom.io/api/*"
  script_name = cloudflare_workers_script.backend_worker.name
}
