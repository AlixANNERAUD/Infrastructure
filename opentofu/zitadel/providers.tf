provider "zitadel" {
  domain       = var.zitadel_domain
  port         = var.zitadel_port
  insecure     = var.zitadel_insecure
  access_token = var.zitadel_token
}
