output "client_ids" {
  description = "Client id of each application."
  # Client ids are public; the provider marks them sensitive
  value = { for name, application in zitadel_application_oidc.application : name => nonsensitive(application.client_id) }
}

output "client_secrets" {
  description = "Client secret of each client_secret application."
  value = {
    for name, application in zitadel_application_oidc.application : name => application.client_secret
    if var.applications[name].authentication == "client_secret"
  }
  sensitive = true
}

output "configured_in" {
  description = "Where each application's client id and secret are pasted, for applications that have one."
  value = {
    for name, application in var.applications : name => application.configured_in
    if application.configured_in != null
  }
}
