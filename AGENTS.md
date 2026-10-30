# AGENTS.md

Ansible playbooks and Docker Compose files that deploy Alix's self-hosted services. Everything here acts on live servers and public DNS, so read before you run.

## Layout

- `services/<service>/` — one folder per service: `deploy.yml` (playbook), `compose.yml`, and any `*.j2` templates or config it copies.
- `hosts/<host>/` — host-level playbooks (packages, networking, `hosts/bruxelles/nextcloud_after_update.yml`); `hosts/bootstrap.yml` and `hosts/replication.yml` apply to several hosts.
- `dns/<zone>.yml` — one playbook per Cloudflare DNS zone (`anneraud.yml`, `xila.yml`, `minitrainstore.yml`, `guenola_sahut.yml`), applied on their own, not by `site.yml`.
- `services/zitadel/applications.yml` + `opentofu/zitadel/` — Zitadel OIDC applications for services outside Ansible; see the readme's "Zitadel applications" section.
- `inventory/hosts.yml` — hosts, plus one group per service naming the host it runs on (`tolgee_anneraud: {hosts: {luxembourg:}}`). Group names use underscores (`ha_linky`).
- `inventory/host_vars/<host>.yml` (or a folder, `inventory/host_vars/bruxelles/`) — per-host settings: connection, `local_dns_host` / `global_dns_host`, `services_root`, `proxy_network`. Put host facts here, not in playbooks.
- `vault/` — **private submodule** (`Infrastructure_vault`) with Ansible Vault files, one per service: `vault/<service>/vault.yml`, plus `vault/ansible/vault.yml` (sudo password) and `vault/cloudflare/vault.yml`.
- `services/website/website` — separate submodule; not part of this repo's code.

## Hosts

| Host | Role | Service root | Reverse proxy |
|---|---|---|---|
| `luxembourg` | Cloud VM with a public IP | `/opt/<service>` | Traefik (`services/traefik`), labels on the external `traefik` network |
| `bruxelles` | Home TrueNAS server | `/mnt/Donnees/Applications_chiffrees/<Service>` | Traefik (`services/traefik`) on the external `proxy` network, routes in `inventory/host_vars/bruxelles/traefik.yml` |
| `pristina` | Home machine | — | — |
| `paris` | Desktop client | — | — |

Luxembourg is reachable from the internet: anything published with `ports:` there is public, because Docker bypasses the host firewall. Keep internal services behind Traefik with the `internal-allowlist@file` middleware instead.

## Tooling

Tools are pinned with uv (`pyproject.toml`, `uv.lock`) and Ansible collections in `requirements.yml`.

```bash
uv sync
uv run ansible-galaxy collection install -r requirements.yml   # into .ansible/collections
uv run yamllint .
uv run ansible-lint
.github/scripts/check-compose.sh                               # docker compose config on every service
(cd roles/compose_service && uv run molecule test)             # runs the role against a local busybox stack (needs Docker)
```

All of them must pass; CI (`.github/workflows/lint.yml`) runs them on every PR and push to `main`. CI has no vault password, so ansible-lint runs against empty placeholder vault files — playbooks must not depend on vault values to parse.

ansible-lint warns `args[module]` on the Cloudflare playbooks: a false positive, `zone` comes from `module_defaults`.

## Conventions

Compose services are deployed with the shared role `roles/compose_service` (see its `defaults/main.yml` and `meta/argument_specs.yml`). A service's `deploy.yml` is only:

```yaml
- name: Deploy Wakapi
  hosts: wakapi                      # the service's inventory group
  become: true
  vars_files:                        # always the ansible vault (sudo password), then the service's, then cloudflare
    - ../../vault/ansible/vault.yml
    - ../../vault/wakapi/vault.yml
    - ../../vault/cloudflare/vault.yml
  roles:
    - role: compose_service
      vars:
        compose_service_name: wakapi
        compose_service_directory: Wakapi   # only when the folder name differs from the service name
        compose_service_user: 568            # also written to .env as USER_ID / GROUP_ID
        compose_service_environment: {...}   # written to .env
        compose_service_files: [{source: config.yml, destination: config/config.yml}]
        compose_service_mounted_files: [repos.sqlite]
        compose_service_dns_records: [{record: wakapi.dera.page}]   # visibility: private for local_dns_host
```

The role creates the folder under the host's `services_root` (permissions only on creation, existing TrueNAS folders keep their ACLs), copies `compose.yml`, writes `.env`, starts the stack and points the DNS records at the host. Stacks are only recreated when their image or configuration changes, and restarted when an extra file changes. Every Compose service uses the role except `services/vault_xila`, which bootstraps its own TLS certificate and must stay unsealed; keep it hand-written. `site.yml` imports every service playbook (`uv run ansible-playbook site.yml --limit <host>`); add new services to it.

Rules:

- Bind-mount paths in `compose.yml` must match what `deploy.yml` creates. A missing file mount makes Docker create a directory in its place.
- Pass UID/GID and secrets to Compose through `.env` (`${USER_ID}:${GROUP_ID}`), not hard-coded twice.
- Every long-running container gets `restart: unless-stopped`, databases included.
- Pin image tags (no `latest`, no untagged images); Dependabot (`.github/dependabot.yml`) opens one grouped PR per ecosystem every Monday. It does not cover `requirements.yml` or `.python-version`: update those by hand.
- Ansible style: FQCN modules (`ansible.builtin.copy`), `true`/`false`, `changed_when` on `command`/`shell`, handlers for restarts.
- Lines that can't be split (DNS TXT records, Traefik rules, long commands) get `# yamllint disable-line rule:line-length`. Never put that comment inside a `|` block scalar: it would become part of the file content; wrap the task in `# yamllint disable/enable rule:line-length` instead.
- New public endpoints should also get a Gatus check in `services/gatus_anneraud/config.yml` or `services/gatus_dera_page/config.yml`, and a row in `readme.md`.

## Hosts access

- Ansible connects as `ansible` with passwordless sudo; `hosts/bootstrap.yml` sets it up and hardens `sshd` on every host except TrueNAS (`truenas` group, configured in its interface). Never widen `automation_ssh_sources` or `ssh_administrators` in `inventory/group_vars/all.yml` without the owner.
- Hosts that need to reach each other use their own account and key with a forced command (see `hosts/replication.yml`), never the `ansible` account.

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
