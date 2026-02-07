# Infrastructure

This repository contains the infrastructure code and documentation for deploying and managing my personnal services.

## Inventory

See [documentation/inventory.md](documentation/inventory.md)

## Services

| Name                                                                   | Description                                   | Access  | Server     | Deployment   | Status                                                                                                                             |
| ---------------------------------------------------------------------- | --------------------------------------------- | ------- | ---------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------- |
| [Accueil](https://wwww.anneraud.fr/)                                   | Services homepage                             | Public  | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_accueil/uptimes/30d/badge.svg)                                        |
| [Bitwarden](https://bitwarden.anneraud.fr/)                            | Password manager (Vaultwarden)                | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_bitwarden-(nextcloud)/uptimes/30d/badge.svg>)                        |
| [Nuage](https://nuage.anneraud.fr/)                                    | Cloud storage and collaboration (Nextcloud)   | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_nuage-(nextcloud)/uptimes/30d/badge.svg>)                            |
| [Automatisation](https://automatisation.anneraud.fr)                   | Workflow automation (n8n)                     | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_automatisation-(n8n)/uptimes/30d/badge.svg>)                         |
| [Maison](https://maison.anneraud.fr/)                                  | Home automation (Home Assistant)              | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_maison-(home-assistant)/uptimes/30d/badge.svg>)                      |
| [Médiathèque](https://mediatheque.anneraud.fr/)                        | Media server (Jellyfin)                       | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_médiathèque-(jellyfin)/uptimes/30d/badge.svg>)                       |
| [Téléchargement](https://telechargement.anneraud.fr/)                  | Download manager (qBittorrent)                | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_téléchargement-(qbittorrent)/uptimes/30d/badge.svg>)                 |
| [Matrix](https://matrix.anneraud.fr/)                                  | Matrix server (Synapse)                       | Public  | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_matrix-(synapse)/uptimes/30d/badge.svg>)                             |
| [Archive](https://archive.anneraud.fr/)                                | Document management (Paperless-ngx)           | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_archive-(paperless-ngx)/uptimes/30d/badge.svg>)                      |
| [Statistiques](https://s.anneraud.fr/)                                 | Analytics (Umami)                             | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_statistiques-(umami)/uptimes/30d/badge.svg>)                         |
| [Notes](https://notes.anneraud.fr/)                                    | Documentation (Docmost)                       | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_notes-(docmost)/uptimes/30d/badge.svg>)                              |
| [Mini Train Store](https://minitrainstore.fr/)                         | Business management (Odoo)                    | Public  | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_mini-train-store-(odoo)/uptimes/30d/badge.svg>)                      |
| [Git](https://git.anneraud.fr/)                                        | Git forge (Gitea)                             | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_git-(gitea)/uptimes/30d/badge.svg>)                                  |
| [Finances](https://finances.anneraud.fr/)                              | Personal finance manager (Firefly III)        | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_finances-(firefly-iii)/uptimes/30d/badge.svg>)                       |
| [Importateur finances](https://importeur-finances.anneraud.fr/)        | Finance data importer (Firefly III importer)  | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_importateur-finances-(firefly-iii-importer)/uptimes/30d/badge.svg>)  |
| [Recettes](https://recettes.anneraud.fr/)                              | Recipe manager (Mealie)                       | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_recettes-(mealie)/uptimes/30d/badge.svg>)                            |
| [Portefolio Alix](https://alix.anneraud.fr/)                           | Personal portfolio (GitHub Pages)             | Public  | -          | -            | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_portefolio-alix-(github-pages)/uptimes/30d/badge.svg>)               |
| [Radarr](https://radarr.anneraud.fr/)                                  | Movie collection manager                      | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_radarr/uptimes/30d/badge.svg)                                         |
| [Sonarr](https://sonarr.anneraud.fr/)                                  | TV show collection manager                    | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_sonarr/uptimes/30d/badge.svg)                                         |
| [Prowlarr](https://prowlarr.anneraud.fr/)                              | Indexer manager                               | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_prowlarr/uptimes/30d/badge.svg)                                       |
| [Bazarr](https://bazarr.anneraud.fr/)                                  | Subtitle manager                              | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_bazarr/uptimes/30d/badge.svg)                                         |
| [Jellyseerr](https://jellyseerr.anneraud.fr/)                          | Media request manager                         | Private | Bruxelles  | TrueNAS Apps | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_jellyseerr/uptimes/30d/badge.svg)                                     |
| [Wakapi](https://wakapi.anneraud.fr)                                   | Coding time tracker                           | Public  | Bruxelles  | Ansible      | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_wakapi/uptimes/30d/badge.svg)                                         |
| [Translation](https://translate.anneraud.fr/)                          | Translation platform (Weblate)                | Private | Bruxelles  | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/services_translation-(weblate)/uptimes/30d/badge.svg>)                        |
| [Proxy Bruxelles](https://nginx.bruxelles.anneraud.fr/)                | Reverse proxy (Nginx Proxy Manager)           | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/infrastructure_proxy-bruxelles-(nginx-proxy-manager)/uptimes/30d/badge.svg>)  |
| [DNS dynamique Bruxelles](https://ddns-updater.bruxelles.anneraud.fr/) | Dynamic DNS updater                           | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/infrastructure_dns-dynamique-bruxelles-(ddns-updater)/uptimes/30d/badge.svg>) |
| [Bruxelles console](https://bruxelles.anneraud.fr/)                    | Server management (TrueNAS)                   | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/infrastructure_bruxelles-console-(truenas)/uptimes/30d/badge.svg>)            |
| [Conteneurs Bruxelles](https://conteneurs.bruxelles.anneraud.fr/)      | Container management (Portainer)              | Private | Bruxelles  | TrueNAS Apps | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/infrastructure_conteneurs-bruxelles-(portainer)/uptimes/30d/badge.svg>)       |
| [État](https://etat.anneraud.fr/)                                      | Service status page                           | Public  | Bruxelles  | TrueNAS Apps | -                                                                                                                                  |
| [VPN](https://tailscale.anneraud.fr/)                                  | Virtual private network (Tailscale/Headscale) | Public  | Luxembourg | Ansible      | ![Status](<https://etat.anneraud.fr/api/v1/endpoints/infrastructure_vpn-(tailscale)/uptimes/30d/badge.svg>)                        |
| [VPN console](https://tailscale.anneraud.fr/admin/)                    | VPN administration console                    | Public  | Luxembourg | Ansible      | ![Status](https://etat.anneraud.fr/api/v1/endpoints/services_vpn-console/uptimes/30d/badge.svg)                                    |
| [Matrix](https://matrix.insa.lol/)                                     | Decentralized communication platform          | Public  | Luxembourg | Ansible      | -                                                                                                                                  |
| [Status (dera.page)](https://status.dera.page/)                        | Service status page                           | Public  | Luxembourg | Ansible      | -                                                                                                                                  |

## Deployment

Deploy a service playbook with Ansible:

```bash
ansible-playbook -i inventory.yml --ask-become-pass services/<service_name>/deploy.yml
```

## Structure

The repository is organized by **service**, with each service containing all its related files:

```
services/
  <service_name>/
    deploy.yml          # Ansible playbook
    compose.yml         # Docker Compose file
    config.yml          # Service configuration
    ...
vault/                  # Private submodule with encrypted secrets
deployments/            # Deployment-specific files
documentation/          # Documentation
```

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
