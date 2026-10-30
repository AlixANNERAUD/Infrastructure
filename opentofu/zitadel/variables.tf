variable "zitadel_domain" {
  description = "Domain of the Zitadel instance."
  type        = string
  default     = "authentification.anneraud.fr"
}

variable "zitadel_port" {
  description = "Port of the Zitadel instance."
  type        = string
  default     = "443"
}

variable "zitadel_insecure" {
  description = "Connect without TLS (only for the throwaway Zitadel in Molecule)."
  type        = bool
  default     = false
}

variable "zitadel_token" {
  description = "Personal access token of a Zitadel service account with the ORG_OWNER role."
  type        = string
  sensitive   = true
}

variable "state_passphrase" {
  description = "Passphrase the state encryption key is derived from (at least 16 characters)."
  type        = string
  sensitive   = true
}

variable "state_path" {
  description = "Path of the encrypted state file."
  type        = string
  default     = "../../vault/zitadel/opentofu.tfstate"
}

variable "applications" {
  description = "OIDC applications, keyed by application name."
  type = map(object({
    project = string
    roles = optional(list(object({
      key          = string
      display_name = string
    })), [])
    redirect_uris    = list(string)
    post_logout_uris = optional(list(string), [])
    # pkce: public client (no secret); client_secret: confidential client
    authentication = optional(string, "pkce")
    # Where the owner pastes the client id and secret, for services managed outside this repository
    configured_in = optional(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for application in values(var.applications) : contains(["pkce", "client_secret"], application.authentication)])
    error_message = "authentication must be pkce or client_secret."
  }

  validation {
    condition     = alltrue([for application in values(var.applications) : length(application.redirect_uris) > 0])
    error_message = "Every application needs at least one redirect URI."
  }
}
