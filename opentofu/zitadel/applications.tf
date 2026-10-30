# Projects, roles and applications all belong to the default organization,
# the one the service account is ORG_OWNER of
data "zitadel_organizations" "default" {
  is_default = true
}

locals {
  organization_id = data.zitadel_organizations.default.ids[0]

  projects = toset([for application in values(var.applications) : application.project])

  # Roles are declared per application but belong to the project
  roles = merge([
    for application in values(var.applications) : {
      for role in application.roles : "${application.project}/${role.key}" => {
        project      = application.project
        key          = role.key
        display_name = role.display_name
      }
    }
  ]...)
}

resource "zitadel_project" "project" {
  for_each = local.projects

  name   = each.value
  org_id = local.organization_id
}

resource "zitadel_project_role" "role" {
  for_each = local.roles

  org_id       = local.organization_id
  project_id   = zitadel_project.project[each.value.project].id
  role_key     = each.value.key
  display_name = each.value.display_name
}

resource "zitadel_application_oidc" "application" {
  for_each = var.applications

  org_id     = local.organization_id
  project_id = zitadel_project.project[each.value.project].id
  name       = each.key

  app_type                  = "OIDC_APP_TYPE_WEB"
  response_types            = ["OIDC_RESPONSE_TYPE_CODE"]
  grant_types               = ["OIDC_GRANT_TYPE_AUTHORIZATION_CODE"]
  auth_method_type          = each.value.authentication == "client_secret" ? "OIDC_AUTH_METHOD_TYPE_BASIC" : "OIDC_AUTH_METHOD_TYPE_NONE"
  redirect_uris             = each.value.redirect_uris
  post_logout_redirect_uris = each.value.post_logout_uris
  # Zitadel only accepts plain-HTTP redirects in development mode
  dev_mode = alltrue([for uri in each.value.redirect_uris : startswith(uri, "http://localhost")])
}
