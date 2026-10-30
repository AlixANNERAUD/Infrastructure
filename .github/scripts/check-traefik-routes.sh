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

# The ACME server is unreachable on purpose: certificates are never requested
docker run -d --name "$container" -p 127.0.0.1::8080 -v "$directory:/dynamic:ro" traefik:v3.7 \
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


def domains(name):
    return routers.get(name, {}).get("tls", {}).get("domains", [])


def certificate(domain):
    return {"main": domain, "sans": [f"*.{domain}"]}


check(certificate("bruxelles.anneraud.fr") in domains("portainer"), "router portainer lacks its certificate")
check(certificate("anneraud.fr") in domains("redirect-anneraud"), "router redirect-anneraud lacks its certificate")
for domain in ["anneraud.fr", "guenola-sahut.fr"]:
    check(certificate(domain) in domains("umami"), f"router umami lacks the {domain} certificate")


def replacement(name):
    return middlewares.get(name, {}).get("redirectRegex", {}).get("replacement", "")


check(replacement("redirect-arnaud").endswith("${1}"), "middleware redirect-arnaud does not keep the path")
check(replacement("redirect-anneraud") and not replacement("redirect-anneraud").endswith("${1}"),
      "middleware redirect-anneraud keeps the path")

for route in routes:
    names = [route["name"]] + [f"{route['name']}-{index}" for index in range(1, len(route.get("paths", [])) + 1)]
    for name in names:
        allowlisted = "internal-allowlist@file" in routers.get(name, {}).get("middlewares", [])
        check(allowlisted == route["internal"], f"router {name} internal allowlist is {allowlisted}")

if failures:
    print("\n".join(failures))
    sys.exit(1)
print(f"{len(routers)} routers enabled")
EOF
