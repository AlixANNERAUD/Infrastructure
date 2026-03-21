# Inventaire

Ce document fournit un inventaire des composants de l'infrastructure, y compris les serveurs, les services et leurs configurations respectives.

## Serveurs

### Bruxelles

Ce serveur héberge la majorité de mes services personnels en utilisant TrueNAS Apps et Ansible pour le déploiement et la gestion. Il a été conçu avec une efficacité énergétique (~20 W au repos) et une fiabilité à l'esprit.

- Système d'exploitation : [TrueNAS Community Edition](https://www.truenas.com/truenas-community-edition/) (basé sur Debian)
- Carte mère : ASRock B550M-ITX/ac
- Processeur : AMD Ryzen 3 PRO 4350G avec Radeon Graphics
- Mémoire : 32 Go DDR4 ECC
- Alimentation : Cooler Master MWE 600 White 230V
- Stockage :
  - Western Digital Black 750 (SSD - 2 To - NVMe - Pool de données ZFS)
  - Western Digital Black 770 (SSD - 2 To - NVMe - Pool de données ZFS)
  - Western Digital Black 7200 (SSD - 2 To - SATA - Pool de données ZFS)
  - Micron 5200 (SSD - 1,9 To - SATA - Pool de données ZFS)
  - Crucial C300 (SSD - 64 Go - SATA - Système TrueNAS)

### Luxembourg

Ce serveur est hébergé sur Oracle Cloud Infrastructure (OCI) et est utilisé pour les services nécessitant une haute disponibilité et un accès externe.

- Système d'exploitation : Ubuntu 24.04 LTS
- Modèle : Instance Oracle Cloud
- Processeur : ARM Ampere A1 (4 cœurs)
- Mémoire : 24 Go
- Stockage : 200 Go
