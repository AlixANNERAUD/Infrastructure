# DNS

All DNS records are managed through [Cloudflare](https://www.cloudflare.com/), which provides a reliable and easy-to-use interface for managing DNS settings.

Most services use CNAME records pointing to the destination server which are:

| Domain                        | Description                      | Access  | Server     | Update  |
| ----------------------------- | -------------------------------- | ------- | ---------- | ------- |
| local.bruxelles.anneraud.fr   | Bruxelles local network access   | Private | Bruxelles  | Static  |
| local.luxembourg.anneraud.fr  | Luxembourg local network access  | Private | Luxembourg | Static  |
| global.bruxelles.anneraud.fr  | Bruxelles global network access  | Public  | Bruxelles  | Dynamic |
| global.luxembourg.anneraud.fr | Luxembourg global network access | Public  | Luxembourg | Static  |
