# DNS

Tous les enregistrements DNS sont gérés via [Cloudflare](https://www.cloudflare.com/), qui offre une interface fiable et facile à utiliser pour gérer les paramètres DNS.

La plupart des services utilisent des enregistrements CNAME pointant vers le serveur de destination, qui sont :

| Domaine                       | Description                      | Accès  | Serveur    | Mise à jour |
| ----------------------------- | -------------------------------- | ------ | ---------- | ----------- |
| local.bruxelles.anneraud.fr   | Accès réseau local à Bruxelles   | Privé  | Bruxelles  | Statique    |
| local.luxembourg.anneraud.fr  | Accès réseau local à Luxembourg  | Privé  | Luxembourg | Statique    |
| global.bruxelles.anneraud.fr  | Accès réseau global à Bruxelles  | Public | Bruxelles  | Dynamique   |
| global.luxembourg.anneraud.fr | Accès réseau global à Luxembourg | Public | Luxembourg | Statique    |

Voir [playbooks/cloudflare/update_dns.yml](../playbooks/cloudflare/update_dns.yml) ou les playbooks de déploiement de services pour la liste complète des enregistrements DNS et leurs configurations.
