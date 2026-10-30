# AGENTS.md

Ansible playbooks and Docker Compose files that deploy Alix's self-hosted services. Everything here acts on live servers and public DNS, so read before you run.

## Layout

- `services/<service>/` — one folder per service: `deploy.yml` (playbook), `compose.yml`, and any `*.j2` templates or config it copies.
- `hosts/<host>/` — host-level playbooks (packages, networking, DNS for the host itself).
- `services/cloudflare/update_dns_*.yml` — DNS zones not owned by a single service.
- `inventory.yml` — hosts and their `local_dns_host` / `global_dns_host`.
- `vault/` — **private submodule** (`Infrastructure_vault`) with Ansible Vault files, one per service: `vault/<service>/vault.yml`, plus `vault/ansible/vault.yml` (sudo password) and `vault/cloudflare/vault.yml`.
- `services/website/website` — separate submodule; not part of this repo's code.

## Hosts

| Host | Role | Service root | Reverse proxy |
|---|---|---|---|
| `luxembourg` | Cloud VM with a public IP | `/opt/<service>` | Traefik (`services/traefik`), labels on the external `traefik` network |
| `bruxelles` | Home TrueNAS server | `/mnt/Donnees/Applications_chiffrees/<Service>` | Nginx Proxy Manager on the external `proxy` network, configured by hand in its UI (not in this repo) |
| `pristina` | Home machine | — | — |
| `paris` | Desktop client | — | — |

Luxembourg is reachable from the internet: anything published with `ports:` there is public, because Docker bypasses the host firewall. Keep internal services behind Traefik with the `internal-allowlist@docker` middleware instead.

## Tooling

Tools are pinned with uv (`pyproject.toml`, `uv.lock`) and Ansible collections in `requirements.yml`.

```bash
uv sync
uv run ansible-galaxy collection install -r requirements.yml   # into .ansible/collections
uv run yamllint .
uv run ansible-lint
.github/scripts/check-compose.sh                               # docker compose config on every service
```

All three must pass; CI (`.github/workflows/lint.yml`) runs them on every PR and push to `main`. CI has no vault password, so ansible-lint runs against empty placeholder vault files — playbooks must not depend on vault values to parse.

ansible-lint warns `args[module]` on the Cloudflare playbooks: a false positive, `zone` comes from `module_defaults`.

## Conventions

A typical `deploy.yml`:

1. `hosts:` the target host, `become: true`, `vars_files:` that **always** include `../../vault/ansible/vault.yml` (sudo password), plus the service's vault and `../../vault/cloudflare/vault.yml` when it touches DNS.
2. Create `root_directory` and data directories owned by the container's UID/GID.
3. Copy `compose.yml` and templates; write `.env` (mode `0600`) from vault variables.
4. `community.docker.docker_compose_v2` with `project_src: "{{ root_directory }}"`.
5. `community.general.cloudflare_dns` CNAME to `global_dns_host` (public service) or `local_dns_host` (LAN/VPN only).

Rules:

- Bind-mount paths in `compose.yml` must match what `deploy.yml` creates. A missing file mount makes Docker create a directory in its place.
- Pass UID/GID and secrets to Compose through `.env` (`${USER_ID}:${GROUP_ID}`), not hard-coded twice.
- Every long-running container gets `restart: unless-stopped`, databases included.
- Pin image tags (no `latest`, no untagged images); Renovate opens PRs for updates.
- Ansible style: FQCN modules (`ansible.builtin.copy`), `true`/`false`, `changed_when` on `command`/`shell`, handlers for restarts.
- Lines that can't be split (DNS TXT records, Traefik rules, long commands) get `# yamllint disable-line rule:line-length`. Never put that comment inside a `|` block scalar: it would become part of the file content; wrap the task in `# yamllint disable/enable rule:line-length` instead.
- New public endpoints should also get a Gatus check in `services/gatus_anneraud/config.yml` or `services/gatus_dera_page/config.yml`, and a row in `readme.md`.

## Secrets

- Never decrypt, print or commit vault contents. Vault files are edited with `ansible-vault edit` after `source source.sh` (caches the password in `$XDG_RUNTIME_DIR`).
- Changing secrets means two commits: one in the `vault` repo (push it first), then one here updating the submodule pointer. Never point the submodule at a commit that isn't pushed.

## Safety

- Do not run `ansible-playbook` against real hosts, change DNS, or force-push without the owner's explicit go-ahead. Linting and `--syntax-check` are fine.
- `dera.page` (the bare domain) normally belongs to a friend's server; `services/matrix_dera_page/bare_domain.yml` switches it temporarily. Don't add permanent records for it elsewhere.

## Git

- Commit as the repository owner only. Do **not** add `Co-Authored-By`, "Generated with" or any other AI attribution to commits or PR descriptions.
- `main` is protected: every change goes through a PR, CI must pass, and PRs are squash-merged. Work on a branch and open the PR with `gh pr create`.
- Commit messages: short imperative subject (`Fix Star History database path`), body explaining why.
