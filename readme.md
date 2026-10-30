# Infrastructure

This repository contains the infrastructure code and documentation for deploying and managing my personnal services.

## Inventory

Hosts and the service-to-host mapping are in [inventory/hosts.yml](inventory/hosts.yml); per-host settings are in [inventory/host_vars/](inventory/host_vars/).

## Services

| Name                                                                   | Description                                  | Access  | Server     | Deployment   | Status                                                                                                                             |
| ---------------------------------------------------------------------- | -------------------------------------------- | ------- | ---------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| [Accueil](https://wwww.anneraud.fr/)                                   | Services homepage                            | Public  | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_accueil/uptimes/30d/badge.svg)                                        |
| [Bichon](https://archive-courriel.anneraud.fr/)                         | Email archive                                | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_bichon/uptimes/30d/badge.svg)                                        |
| [Bitwarden](https://bitwarden.anneraud.fr/)                            | Password manager (Vaultwarden)               | Public  | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_bitwarden/uptimes/30d/badge.svg)                                      |
| [Collabora](https://collabora.anneraud.fr/)                            | Online office suite                           | Public  | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_collabora/uptimes/30d/badge.svg)                                     |
| [Nuage](https://nuage.anneraud.fr/)                                    | Cloud storage and collaboration (Nextcloud)  | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_nuage-(nextcloud)/uptimes/30d/badge.svg>)                            |
| [Automatisation](https://automatisation.anneraud.fr)                   | Workflow automation (n8n)                    | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_automatisation-(n8n)/uptimes/30d/badge.svg>)                         |
| [Maison](https://maison.anneraud.fr/)                                  | Home automation (Home Assistant)             | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_maison-(home-assistant)/uptimes/30d/badge.svg>)                      |
| [Médiathèque](https://mediatheque.anneraud.fr/)                        | Media server (Jellyfin)                      | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_médiathèque-(jellyfin)/uptimes/30d/badge.svg>)                       |
| [MeTube](https://metube.anneraud.fr/)                                  | Video downloader                              | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_metube/uptimes/30d/badge.svg)                                         |
| [MeshCentral](https://parc.anneraud.fr/)                               | Remote device management                      | Public  | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_meshcentral/uptimes/30d/badge.svg)                                    |
| [Téléchargement](https://telechargement.anneraud.fr/)                  | Download manager (qBittorrent)               | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_téléchargement-(qbittorrent)/uptimes/30d/badge.svg>)                 |
| [Matrix](https://matrix.anneraud.fr/)                                  | Matrix server (Synapse)                      | Public  | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_matrix-(synapse)/uptimes/30d/badge.svg>)                             |
| [Archive](https://archive.anneraud.fr/)                                | Document management (Paperless-ngx)          | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_archive-(paperless-ngx)/uptimes/30d/badge.svg>)                      |
| [Statistiques](https://s.anneraud.fr/)                                 | Analytics (Umami)                            | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_statistiques-(umami)/uptimes/30d/badge.svg>)                         |
| [Notes](https://notes.anneraud.fr/)                                    | Documentation (Docmost)                      | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_notes-(docmost)/uptimes/30d/badge.svg>)                              |
| [Assistant](https://assistant.anneraud.fr/)                            | AI assistant (Open WebUI)                    | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_assistant-(open-webui)/uptimes/30d/badge.svg>)                       |
| [Recherche](https://recherche.anneraud.fr/)                            | Search engine (SearXNG)                      | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_recherche-(searxng)/uptimes/30d/badge.svg>)                           |
| [Authentification](https://authentification.anneraud.fr/)              | Identity provider (Zitadel)                  | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_authentification-(zitadel)/uptimes/30d/badge.svg>)                   |
| [PDF](https://pdf.anneraud.fr/)                                        | PDF management (BentoPDF)                    | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_pdf-(bentopdf)/uptimes/30d/badge.svg>)                               |
| [Mini Train Store](https://minitrainstore.fr/)                         | Business management (Odoo)                   | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_mini-train-store-(odoo)/uptimes/30d/badge.svg>)                      |
| [Git](https://git.anneraud.fr/)                                        | Git forge (Gitea)                            | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_git-(gitea)/uptimes/30d/badge.svg>)                                  |
| [Finances](https://finances.anneraud.fr/)                              | Personal finance manager (Firefly III)       | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_finances-(firefly-iii)/uptimes/30d/badge.svg>)                       |
| [Importateur finances](https://importeur-finances.anneraud.fr/)        | Finance data importer (Firefly III importer) | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_importateur-finances-(firefly-iii-importer)/uptimes/30d/badge.svg>)  |
| [Recettes](https://recettes.anneraud.fr/)                              | Recipe manager (Mealie)                      | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_recettes-(mealie)/uptimes/30d/badge.svg>)                            |
| [Portefolio Alix](https://alix.anneraud.fr/)                           | Personal portfolio (GitHub Pages)            | Public  | -          | -            | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_portefolio-alix-(github-pages)/uptimes/30d/badge.svg>)               |
| [Radarr](https://radarr.anneraud.fr/)                                  | Movie collection manager                     | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_radarr/uptimes/30d/badge.svg)                                         |
| [Sonarr](https://sonarr.anneraud.fr/)                                  | TV show collection manager                   | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_sonarr/uptimes/30d/badge.svg)                                         |
| [Prowlarr](https://prowlarr.anneraud.fr/)                              | Indexer manager                              | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_prowlarr/uptimes/30d/badge.svg)                                       |
| [Bazarr](https://bazarr.anneraud.fr/)                                  | Subtitle manager                             | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_bazarr/uptimes/30d/badge.svg)                                         |
| [Jellyseerr](https://jellyseerr.anneraud.fr/)                          | Media request manager                        | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_jellyseerr/uptimes/30d/badge.svg)                                     |
| [Wakapi](https://wakapi.anneraud.fr)                                   | Coding time tracker                          | Public  | Bruxelles  | Ansible      | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_wakapi/uptimes/30d/badge.svg)                                         |
| [Translation](https://translate.anneraud.fr/)                          | Translation platform (Tolgee)                | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_translation-(tolgee)/uptimes/30d/badge.svg>)                         |
| [Vault Xila](https://vault.xila.dev/ui/)                                | Xila signing service (OpenBao)               | Private | Bruxelles  | Ansible      | ![Status](https://etat.anneraud.fr/api/v1/endpoints/administration_vault-xila/uptimes/30d/badge.svg)                              |
| [Proxy Bruxelles](https://traefik.bruxelles.anneraud.fr/)              | Reverse proxy (Traefik)                      | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_proxy-bruxelles-(traefik)/uptimes/30d/badge.svg>)              |
| [DNS dynamique Bruxelles](https://ddns-updater.bruxelles.anneraud.fr/) | Dynamic DNS updater                          | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_dns-dynamique-bruxelles-(ddns-updater)/uptimes/30d/badge.svg>) |
| [Bruxelles console](https://bruxelles.anneraud.fr/)                    | Server management (TrueNAS)                  | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_bruxelles-console-(truenas)/uptimes/30d/badge.svg>)            |
| [Conteneurs Bruxelles](https://conteneurs.bruxelles.anneraud.fr/)      | Container management (Portainer)             | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_conteneurs-bruxelles-(portainer)/uptimes/30d/badge.svg>)       |
| [Databasus](https://databasus.anneraud.fr/)                            | Database management (Adminer)                | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_databasus/uptimes/30d/badge.svg>)                    |
| [Cockpit (Luxembourg)](https://cockpit.luxembourg.anneraud.fr/)        | Server management (Cockpit)                  | Private | Luxembourg | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_cockpit-(luxembourg)/uptimes/30d/badge.svg>)                      |
| [Vigie](https://vigie.anneraud.fr/)                                    | Monitoring (VictoriaMetrics, Grafana)        | Private | Luxembourg | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_vigie-(grafana)/uptimes/30d/badge.svg>)                           |
| [État](https://etat.anneraud.fr/)                                      | Service status page                          | Public  | Bruxelles  | TrueNAS Apps | -                                                                                                                                  |
| [VPN](https://netbird.anneraud.fr/)                                    | Virtual private network (Netbird)            | Public  | Luxembourg | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/administration_vpn-(netbird)/uptimes/30d/badge.svg>)                          |
| [VPN console](https://netbird.anneraud.fr/admin/)                      | VPN administration console                   | Public  | Luxembourg | Ansible      | ![Status](https://etat.anneraud.fr/api/v1/endpoints/administration_vpn-(netbird)/uptimes/30d/badge.svg)                              |
| [Matrix](https://matrix.insa.lol/)                                     | Decentralized communication platform         | Public  | Luxembourg | Ansible      | -                                                                                                                                  |
| [Status (dera.page)](https://status.dera.page/)                        | Service status page                          | Public  | Luxembourg | Ansible      | -                                                                                                                                  |

## Deployment

Install [uv](https://docs.astral.sh/uv/) and [mise](https://mise.jdx.dev/), then the pinned tools (Ansible, ansible-lint, yamllint, OpenTofu for Zitadel's applications) and Ansible collections:

```bash
mise install
mise run setup
source source.sh          # once per session: caches the vault password
```

Common commands are mise tasks (`mise tasks` lists them). They run with the tools from `mise.toml` on `PATH`, so OpenTofu is there for the Zitadel role. Arguments are passed on to the command:

```bash
mise deploy services/<service_name>/deploy.yml   # deploy one service
mise deploy site.yml --limit bruxelles           # everything on one host (or everything without --limit)
mise preview site.yml --limit bruxelles          # what would change (--check --diff), without changing it
mise vault vault/<service_name>/vault.yml        # edit a vault file
mise lint                                        # yamllint, ansible-lint, docker compose config
mise test                                        # Molecule scenarios of the roles (needs Docker)
```

`mise deploy …` is short for `mise run deploy …` and for `mise exec -- uv run ansible-playbook …`.

## Ansible account

Ansible connects to every host as `ansible`: SSH key only (`~/.ssh/ansible.pub`, accepted from the networks in `inventory/group_vars/all.yml`), passwordless sudo, locked password. A hardware-backed key (`ssh-keygen -t ed25519-sk`) is recommended.

Set it up, or update it, with:

```bash
mise deploy hosts/bootstrap.yml --limit <host>                                # existing host
mise deploy hosts/bootstrap.yml --limit <host> -u <you> --ask-become-pass     # new host, added to the inventory first
```

The playbook also hardens `sshd` (no passwords, no root login, only `ansible` and `ssh_administrators`). It refuses to run if the current connection doesn't come from an allowed network. When a host can't be reached, or sudo needs a password nobody provided, it prints the commands to run on that host by hand and skips it.

**TrueNAS (Bruxelles)** manages users and `sshd` in its own interface, which would undo changes made over SSH. The playbook only checks it (reachable, the key with its `from=` restriction, passwordless sudo, password login off) and prints what to change in the interface.

### Replication

`hosts/replication.yml` gives each client in the `replication` group a `replication` account and key, and installs a forced command on Bruxelles that runs one TrueNAS replication task, so the TrueNAS API key never leaves Bruxelles. Once, before deploying it:

1. Deploy: `mise deploy hosts/replication.yml`. Until the `replication` user exists in TrueNAS, it explains how to create it.
2. Paste the `command="…",restrict ssh-ed25519 …` lines it prints into that user's *Authorized Keys*; it prints them only while they are missing.

## Structure

```
inventory/              # Hosts, groups and per-host settings
roles/                  # Reusable roles (compose_service, ...)
services/
  <service>/            # One folder per deployable stack
    deploy.yml          # Ansible playbook
    compose.yml         # Docker Compose file
    ...                 # Templates and configuration it copies
hosts/                  # Host-level playbooks (bootstrap, replication, hosts/<host>/...)
dns/                    # One playbook per Cloudflare DNS zone
site.yml                # Deploys every service (DNS zones are applied with dns/*.yml)
vault/                  # Private submodule with encrypted secrets
.github/                # CI workflows and check scripts
```

## Vigie

Vigie (`services/vigie`) runs on Luxembourg: VictoriaMetrics (3 months of retention, 30 s scrape interval) and Grafana at `https://vigie.anneraud.fr/`, reachable only through Traefik's internal allowlist. It scrapes the metrics of both Traefik instances (Luxembourg and Bruxelles) and Grafana alerts a Home Assistant webhook on 5xx errors, high latency and unreachable targets. Grafana login goes through Zitadel (role `vigie-admin` maps to Grafana `Admin`, everyone else is `Viewer`); the local admin login stays available as a fallback.

Prerequisites:

- `vault/vigie/vault.yml` holds `vigie_grafana_admin_password` and `vigie_home_assistant_webhook_id`.
- Home Assistant has an automation with a webhook trigger whose id is `vigie_home_assistant_webhook_id`, with `local_only: false` (Grafana calls it through `maison.anneraud.fr` from Luxembourg, not from the home network).
- `vigie_grafana_admin_password` only applies on Grafana's first start, when it creates its database. To rotate it afterwards, run `docker exec -it vigie-grafana-1 grafana cli admin reset-admin-password <new password>` on Luxembourg, then update the vault.
- `vault/zitadel/vault.yml` holds `zitadel_automation_token` and `zitadel_state_passphrase`. Without them, the deploy goes on with OAuth off and only the local admin login. If provisioning fails, Grafana keeps the Zitadel login of the previous deploy (OAuth stays off when there was none). When the apply changes the applications, commit `vault/zitadel/opentofu.tfstate` in the vault repository.
- The deploy provisions the Zitadel application with OpenTofu, so run it with `mise deploy services/vigie/deploy.yml` (mise puts `tofu` on `PATH`). A missing `tofu` means the playbook was run without mise.
- The Bruxelles scrape goes from Luxembourg to Bruxelles over Netbird and relies on Bruxelles' Traefik internal allowlist accepting the VPN range.

## Zitadel applications

OIDC applications of services managed outside Ansible are declared in `opentofu/zitadel/applications.auto.tfvars` and provisioned with OpenTofu. To add one:

1. Add an entry to `applications.auto.tfvars` (set `authentication = "client_secret"` and `configured_in` when the service needs a secret pasted in).
2. Run `mise deploy services/zitadel/applications.yml`. It prints the issuer, client id and `configured_in`, and writes client secrets to `~/.config/infrastructure/zitadel/<application>.secret` (mode `0600`). Without `zitadel_automation_token` and `zitadel_state_passphrase` in `vault/zitadel/vault.yml`, it prints how to create them.
3. Commit the updated `vault/zitadel/opentofu.tfstate` in the vault repository.

## Vault

Source the vault password file path:

```bash
source source.sh
```

Then edit or view vault files with:

```bash
ansible-vault edit vault/...
ansible-vault view vault/...
```
