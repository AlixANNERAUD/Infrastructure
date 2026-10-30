#!/usr/bin/env bash
# Render Bruxelles' Traefik routes and load them, with the shared policy, in a
# real Traefik: every router must be enabled and match the route data.
set -euo pipefail

directory=$(mktemp -d)
container=check-traefik-routes-$$
cleanup() {
    docker rm -f "$container" > /dev/null 2>&1 || true
    rm -rf "$directory"
}
trap cleanup EXIT

if ! output=$(uv run ansible bruxelles -c local -e "ansible_python_interpreter=$(uv run which python)" \
    -m ansible.builtin.template -a "src=services/traefik/routes.yml.j2 dest=$directory/routes.yml"); then
    echo "$output"
    exit 1
fi
cp services/traefik/policy.yml "$directory/policy.yml"
chmod -R a+rX "$directory"

# Same image as the deployed Traefik, so Dependabot bumps both at once
image=$(sed -n 's/^ *image: "\{0,1\}\(traefik:[^"]*\)"\{0,1\}$/\1/p' services/traefik/compose.yml)

# The ACME server is unreachable on purpose: certificates are never requested
docker run -d --name "$container" -p 127.0.0.1::8080 -v "$directory:/dynamic:ro" "$image" \
    --api.insecure=true \
    --providers.file.directory=/dynamic \
    --certificatesresolvers.letsencrypt.acme.storage=/tmp/acme.json \
    --certificatesresolvers.letsencrypt.acme.caServer=https://127.0.0.1:1/directory \
    --certificatesresolvers.letsencrypt.acme.tlsChallenge=true \
    --entryPoints.web-secure.address=:8443 > /dev/null
api="http://$(docker port "$container" 8080/tcp | head -n 1)/api"

for _ in $(seq 30); do
    if curl -fs "$api/overview" > /dev/null; then
        break
    fi
    sleep 1
done
# Let the file provider load its directory
sleep 2
curl -fs "$api/http/routers?per_page=1000" > "$directory/routers.json"
curl -fs "$api/http/middlewares?per_page=1000" > "$directory/middlewares.json"

uv run python - "$directory" <<'EOF'
import json
import sys
from pathlib import Path

import yaml

directory = Path(sys.argv[1])
data = yaml.safe_load(Path("inventory/host_vars/bruxelles/traefik.yml").read_text())
routes = data["traefik_routes"]
redirects = data["traefik_redirects"]
routers = {
    router["name"].removesuffix("@file"): router
    for router in json.loads((directory / "routers.json").read_text())
    if router["provider"] == "file"
}
middlewares = {
    middleware["name"].removesuffix("@file"): middleware
    for middleware in json.loads((directory / "middlewares.json").read_text())
    if middleware["provider"] == "file"
}
failures = []


def check(condition, message):
    if not condition:
        failures.append(message)


for name, router in sorted(routers.items()):
    check(router["status"] == "enabled", f"router {name} is {router['status']}: {router.get('error')}")

expected = len(routes) + sum(len(route.get("paths", [])) for route in routes) + len(redirects)
check(len(routers) == expected, f"{len(routers)} routers instead of {expected}")

check(
    routers.get("umami", {}).get("rule") == "Host(`s.anneraud.fr`) || Host(`s.guenola-sahut.fr`)",
    "router umami has the wrong rule",
)
# A route with a prefix only takes that path, so the rest of its host keeps its other routers (here a redirect)
check(
    routers.get("matrix-delegation", {}).get("rule") == "(Host(`anneraud.fr`)) && PathPrefix(`/.well-known/matrix`)",
    "router matrix-delegation has the wrong rule",
)


def domains(name):
    return routers.get(name, {}).get("tls", {}).get("domains", [])


def certificate(domain):
    return {"main": domain, "sans": [f"*.{domain}"]}


def zone(host):
    labels = host.split(".")
    return host if len(labels) == 2 else ".".join(labels[1:])


# Every zone's wildcard is requested by exactly one router: concurrent orders for the same zone break each other
hosts = [host for entry in routes + redirects for host in entry["hosts"]]
requesters = {}
for name, router in routers.items():
    tls = router.get("tls", {})
    check(bool(tls.get("domains")) == bool(tls.get("certResolver")), f"router {name} has a resolver without domains or the reverse")
    for request in tls.get("domains", []):
        check(request == certificate(request["main"]), f"router {name} requests {request}")
        requesters.setdefault(request["main"], []).append(name)
check(set(requesters) == {zone(host) for host in hosts}, f"requested zones {sorted(requesters)}")
for requested_zone, names in requesters.items():
    check(len(names) == 1, f"zone {requested_zone} requested by {names}")
check(requesters.get("bruxelles.anneraud.fr") == ["portainer"], "bruxelles.anneraud.fr is not requested by portainer")
check(requesters.get("guenola-sahut.fr") == ["umami"], "guenola-sahut.fr is not requested by umami")


def replacement(name):
    return middlewares.get(name, {}).get("redirectRegex", {}).get("replacement", "")


check(replacement("redirect-arnaud").endswith("${1}"), "middleware redirect-arnaud does not keep the path")
check(replacement("redirect-anneraud") and not replacement("redirect-anneraud").endswith("${1}"),
      "middleware redirect-anneraud keeps the path")

for route in routes:
    # A path inherits its route's allowlist unless it sets its own
    expectations = {route["name"]: route["internal"]}
    for index, path in enumerate(route.get("paths", []), start=1):
        expectations[f"{route['name']}-{index}"] = path.get("internal", route["internal"])
    for name, internal in expectations.items():
        allowlisted = "internal-allowlist@file" in routers.get(name, {}).get("middlewares", [])
        check(allowlisted == internal, f"router {name} internal allowlist is {allowlisted}")

# Synapse's admin API stays internal while the rest of matrix.anneraud.fr is public
check("internal-allowlist@file" in routers.get("synapse-1", {}).get("middlewares", []), "router synapse-1 is not allowlisted")
check("internal-allowlist@file" not in routers.get("synapse", {}).get("middlewares", []), "router synapse is allowlisted")
check(
    routers.get("synapse-1", {}).get("rule") == "(Host(`matrix.anneraud.fr`)) && PathPrefix(`/_synapse/admin`)",
    "router synapse-1 has the wrong rule",
)

# Sites proxied by Cloudflare must refuse connections that skip it, and nothing else may
cloudflare_networks = yaml.safe_load(Path("inventory/group_vars/all.yml").read_text())["cloudflare_networks"]
cloudflare_routers = {"odoo-minitrainstore", "odoo-guenola-sahut", "redirect-minitrainstore", "redirect-guenola-sahut"}
expected_cloudflare = {route["name"] for route in routes if route.get("cloudflare_only")} | {
    f"redirect-{redirect['name']}" for redirect in redirects if redirect.get("cloudflare_only")
}
check(expected_cloudflare == cloudflare_routers, f"cloudflare_only is set on {sorted(expected_cloudflare)}")
check(cloudflare_routers <= set(routers), f"routers missing: {sorted(cloudflare_routers - set(routers))}")
for name, router in sorted(routers.items()):
    restricted = "cloudflare-only@file" in router.get("middlewares", [])
    check(restricted == (name in cloudflare_routers), f"router {name} Cloudflare restriction is {restricted}")
# A redirect replies on its own, so every restriction must run before it
for name, router in sorted(routers.items()):
    chain = router.get("middlewares", [])
    redirecting = [position for position, middleware in enumerate(chain) if middleware.startswith("redirect-") or middleware.endswith("-redirect@file")]
    for restriction in ("cloudflare-only@file", "internal-allowlist@file"):
        if restriction in chain and redirecting:
            check(chain.index(restriction) < min(redirecting), f"router {name} runs {restriction} after a redirect")
check(
    middlewares.get("cloudflare-only", {}).get("ipAllowList", {}).get("sourceRange") == cloudflare_networks,
    "middleware cloudflare-only does not allow exactly cloudflare_networks",
)

if failures:
    print("\n".join(failures))
    sys.exit(1)
print(f"{len(routers)} routers enabled")
EOF
