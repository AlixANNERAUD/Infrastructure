# Infrastructure

This repository contains the infrastructure code and documentation for deploying and managing my personnal services.

## Inventory

See [documentation/inventory.md](documentation/inventory.md)

## Services

| Name                                                                   | Description                                   | Access  | Server     | Deployment   |
| ---------------------------------------------------------------------- | --------------------------------------------- | ------- | ---------- | ------------ |
| [Accueil](https://wwww.anneraud.fr/)                                   | Services homepage                             | Public  | Bruxelles  | TrueNAS Apps |
| [Bitwarden](https://bitwarden.anneraud.fr/)                            | Password manager (Vaultwarden)                | Public  | Bruxelles  | TrueNAS Apps |
| [Nuage](https://nuage.anneraud.fr/)                                    | Cloud storage and collaboration (Nextcloud)   | Public  | Bruxelles  | TrueNAS Apps |
| [Galerie](https://galerie.anneraud.fr)                                 | Photo management (Immich)                     | Public  | Bruxelles  | TrueNAS Apps |
| [Automatisation](https://automatisation.anneraud.fr)                   | Workflow automation (n8n)                     | Private | Bruxelles  | TrueNAS Apps |
| [Maison](https://maison.anneraud.fr/)                                  | Home automation (Home Assistant)              | Public  | Bruxelles  | TrueNAS Apps |
| [Médiathèque](https://mediatheque.anneraud.fr/)                        | Media server (Jellyfin)                       | Public  | Bruxelles  | TrueNAS Apps |
| [Téléchargement](https://telechargement.anneraud.fr/)                  | Download manager (qBittorrent)                | Private | Bruxelles  | Ansible      |
| [Archive](https://archive.anneraud.fr/)                                | Document management (Paperless-ngx)           | Private | Bruxelles  | TrueNAS Apps |
| [Statistiques](https://s.anneraud.fr/)                                 | Analytics (Umami)                             | Public  | Bruxelles  | TrueNAS Apps |
| [Notes](https://notes.anneraud.fr/)                                    | Documentation (Docmost)                       | Private | Bruxelles  | Ansible      |
| [Arnaud](https://arnaud.anneraud.fr/)                                  | Business management (Odoo)                    | Private | Bruxelles  | TrueNAS Apps |
| [Git](https://git.anneraud.fr/)                                        | Git forge (Gitea)                             | Private | Bruxelles  | TrueNAS Apps |
| [Finances](https://finances.anneraud.fr/)                              | Personal finance manager (Firefly III)        | Private | Bruxelles  | TrueNAS Apps |
| [Importateur finances](https://importeur-finances.anneraud.fr/)        | Finance data importer (Firefly III importer)  | Private | Bruxelles  | TrueNAS Apps |
| [Recettes](https://recettes.anneraud.fr/)                              | Recipe manager (Mealie)                       | Private | Bruxelles  | TrueNAS Apps |
| [Portefolio Alix](https://alix.anneraud.fr/)                           | Personal portfolio (GitHub Pages)             | Public  | -          | -            |
| [Radarr](https://radarr.anneraud.fr/)                                  | Movie collection manager                      | Private | Bruxelles  | TrueNAS Apps |
| [Sonarr](https://sonarr.anneraud.fr/)                                  | TV show collection manager                    | Private | Bruxelles  | TrueNAS Apps |
| [Prowlarr](https://prowlarr.anneraud.fr/)                              | Indexer manager                               | Private | Bruxelles  | TrueNAS Apps |
| [Bazarr](https://bazarr.anneraud.fr/)                                  | Subtitle manager                              | Private | Bruxelles  | TrueNAS Apps |
| [Jellyseerr](https://jellyseerr.anneraud.fr/)                          | Media request manager                         | Private | Bruxelles  | TrueNAS Apps |
| [Wakapi](https://wakapi.anneraud.fr)                                   | Coding time tracker                           | Public  | Bruxelles  | Ansible      |
| [Proxy Bruxelles](https://nginx.bruxelles.anneraud.fr/)                | Reverse proxy (Nginx Proxy Manager)           | Private | Bruxelles  | TrueNAS Apps |
| [DNS dynamique Bruxelles](https://ddns-updater.bruxelles.anneraud.fr/) | Dynamic DNS updater                           | Private | Bruxelles  | TrueNAS Apps |
| [Bruxelles console](https://bruxelles.anneraud.fr/)                    | Server management (TrueNAS)                   | Private | Bruxelles  | TrueNAS Apps |
| [Conteneurs Bruxelles](https://conteneurs.bruxelles.anneraud.fr/)      | Container management (Portainer)              | Private | Bruxelles  | TrueNAS Apps |
| [État](https://etat.anneraud.fr/)                                      | Service status page                           | Public  | Bruxelles  | TrueNAS Apps |
| [VPN](https://tailscale.anneraud.fr/)                                  | Virtual private network (Tailscale/Headscale) | Public  | Luxembourg | Ansible      |
| [VPN console](https://tailscale.anneraud.fr/admin/)                    | VPN administration console                    | Public  | Luxembourg | Ansible      |
| [Matrix](https://matrix.insa.lol/)                                     | Decentralized communication platform          | Public  | Luxembourg | Ansible      |
| [Status (dera.page)](https://status.dera.page/)                        | Service status page                           | Public  | Luxembourg | Ansible      |

## Deployment

Deploy a playbook with Ansible:

```bash
ansible-playbook -i inventory.ini --ask-become-pass playbooks/...
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