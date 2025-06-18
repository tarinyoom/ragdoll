terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "tarinyoom-terraform-state-bucket-663a64"
    key            = "raggle/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# --- Cloudflare Pages Project ---
resource "cloudflare_pages_project" "frontend" {
  name       = "ragdoll-frontend"
  account_id = var.cloudflare_account_id

  production_branch = "main"

  build_config {
    build_command   = "npm run build"
    destination_dir = "dist"
  }
}

# --- Optional: Custom Domain Mapping ---
resource "cloudflare_pages_domain" "frontend_domain" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.frontend.name
  domain       = "ragdoll.tarinyoom.io"
}

# --- Outputs ---
output "frontend_project_url" {
  value = "https://${cloudflare_pages_domain.frontend_domain.domain}"
}
