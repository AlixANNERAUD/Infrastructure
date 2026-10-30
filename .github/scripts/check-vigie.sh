#!/usr/bin/env bash
# Lay Vigie out as services/vigie/deploy.yml does, start it with its own
# Compose file, feed VictoriaMetrics sample Traefik metrics and check what
# Grafana provisioned: datasource, dashboard and alert rules, and that the
# rules evaluate as expected.
set -euo pipefail

directory=$(mktemp -d)
project=check-vigie-$$
network=$project-proxy
password=check-vigie-password
compose() {
    docker compose -p "$project" --project-directory "$directory" \
        -f "$directory/compose.yml" -f "$directory/compose.check.yml" "$@"
}
cleanup() {
    status=$?
    if [ "$status" -ne 0 ] && [ -f "$directory/compose.yml" ]; then
        compose logs --no-color --tail 50 || true
    fi
    compose down --volumes --timeout 5 > /dev/null 2>&1 || true
    docker network rm "$network" > /dev/null 2>&1 || true
    rm -rf "$directory"
    exit "$status"
}
trap cleanup EXIT

# Copy the files and render the templates to the destinations deploy.yml gives them
uv run python - "$directory" > "$directory/layout" <<'EOF'
import sys
from pathlib import Path

import yaml

play = yaml.safe_load(Path("services/vigie/deploy.yml").read_text())[0]
role = next(role for role in play["roles"] if role["role"] == "compose_service")["vars"]
for directory in role.get("compose_service_directories", []):
    print("directory", directory, directory)
for entry in role.get("compose_service_files", []):
    print("file", entry["source"], entry["destination"])
for entry in role.get("compose_service_templates", []):
    print("template", entry["source"], entry["destination"])
EOF
cp services/vigie/compose.yml "$directory/compose.yml"
while read -r kind source destination; do
    mkdir -p "$(dirname "$directory/$destination")"
    case "$kind" in
        directory) mkdir -p "$directory/$destination" ;;
        file) cp "services/vigie/$source" "$directory/$destination" ;;
        template)
            # Placeholder vault values; rules are evaluated every 10 s to keep the check short
            if ! output=$(uv run ansible luxembourg -c local -e "ansible_python_interpreter=$(uv run which python)" \
                -e vigie_home_assistant_webhook_id=check-vigie-webhook \
                -e vigie_grafana_admin_password=$password \
                -e vigie_alert_evaluation_interval=10s \
                -m ansible.builtin.template -a "src=services/vigie/$source dest=$directory/$destination"); then
                echo "$output"
                exit 1
            fi
            ;;
    esac
done < "$directory/layout"
chmod -R a+rX "$directory"

# Containers run as the current user, who owns the data folders here
cat > "$directory/.env" <<EOF
USER_ID=$(id -u)
GROUP_ID=$(id -g)
PROXY_NETWORK=$network
GRAFANA_ADMIN_PASSWORD=$password
EOF
cat > "$directory/compose.check.yml" <<'EOF'
services:
  victoriametrics:
    ports: ["127.0.0.1::8428"]
  grafana:
    ports: ["127.0.0.1::3000"]
EOF
docker network create "$network" > /dev/null

# VictoriaMetrics must accept the scrape configuration as it is
compose run --rm --no-deps victoriametrics \
    -promscrape.config=/etc/vigie/scrape.yml -dryRun

compose up -d --wait --quiet-pull
metrics="http://$(compose port victoriametrics 8428)"
grafana="http://admin:$password@$(compose port grafana 3000)"

ready=false
for _ in $(seq 60); do
    if curl -fs "$metrics/health" > /dev/null && curl -fs "$grafana/api/health" > /dev/null; then
        ready=true
        break
    fi
    sleep 2
done
if [ "$ready" != true ]; then
    echo "VictoriaMetrics or Grafana did not become healthy within 2 minutes"
    exit 1
fi

# Sample Traefik counters for the last 8 minutes, one point every 30 s:
# app@file answers 9 % of its requests with a 5xx (the error rule must fire)
# and quickly (the latency rule must not); nextcloud@file and matrix-dera-page@docker
# are slow but excluded. The latency rule reads the last 5 minutes, which keep
# at least 20 requests per service for the whole 2-minute poll
now=$(date +%s)
uv run python - "$now" > "$directory/samples.prom" <<'EOF'
import sys

now = int(sys.argv[1])
for step in range(17):
    timestamp = (now - 480 + step * 30) * 1000
    successes, errors = step * 10, step
    for service, code, count in (("app@file", "200", successes), ("app@file", "500", errors),
                                 ("nextcloud@file", "200", successes), ("matrix-dera-page@docker", "200", successes)):
        labels = f'service="{service}",code="{code}",method="GET",protocol="http",host="bruxelles"'
        print(f"traefik_service_requests_total{{{labels}}} {count} {timestamp}")
    for service in ("app@file", "nextcloud@file", "matrix-dera-page@docker"):
        total = successes + errors if service == "app@file" else successes
        labels = f'service="{service}",code="200",method="GET",protocol="http",host="bruxelles"'
        for bound in ("0.1", "0.3", "1.2", "5.0", "+Inf"):
            fast = service == "app@file" or bound in ("5.0", "+Inf")
            print(f'traefik_service_request_duration_seconds_bucket{{{labels},le="{bound}"}} {total if fast else 0} {timestamp}')
        print(f"traefik_service_request_duration_seconds_count{{{labels}}} {total} {timestamp}")
        print(f"traefik_service_request_duration_seconds_sum{{{labels}}} {total * 0.05 if service == 'app@file' else total * 4} {timestamp}")
EOF
curl -fsS --data-binary "@$directory/samples.prom" "$metrics/api/v1/import/prometheus"
curl -fsS "$metrics/internal/force_flush" > /dev/null

cat > "$directory/check.py" <<'EOF'
import json
import sys
from pathlib import Path

directory = Path(sys.argv[1])


def load(name):
    try:
        return json.loads((directory / name).read_text())
    except json.JSONDecodeError:
        return {}


failures = []


def check(condition, message):
    if not condition:
        failures.append(message)


targets = {
    target["labels"].get("host"): target["scrapeUrl"]
    for target in load("targets.json").get("data", {}).get("activeTargets", [])
}
check(
    targets == {"luxembourg": "http://traefik:8082/metrics", "bruxelles": "https://traefik.bruxelles.anneraud.fr/metrics"},
    f"scrape targets are {targets}",
)

datasource = load("datasource.json")
check(datasource.get("status") == "OK", f"datasource health is {datasource}")

dashboard = load("dashboard.json").get("dashboard", {})
check(dashboard.get("uid") == "traefik", "dashboard traefik is missing")
variables = [variable["name"] for variable in dashboard.get("templating", {}).get("list", [])]
check("host" in variables, f"dashboard variables are {variables}")

groups = load("rules.json").get("data", {}).get("groups", [])
rules = {rule["name"]: rule for group in groups if group.get("file") == "Vigie" for rule in group["rules"]}
expected = {"Traefik server errors", "Traefik slow responses", "Traefik metrics missing"}
check(set(rules) == expected, f"rules in folder Vigie are {sorted(rules)}")
for name, rule in rules.items():
    check(rule.get("health") == "ok" and not rule.get("lastError"), f"rule {name} health {rule.get('health')}: {rule.get('lastError')}")
# The error rule waits 10 minutes before firing, so pending means its condition holds
errors = rules.get("Traefik server errors", {})
check(errors.get("state") in ("pending", "firing"), f"rule Traefik server errors is {errors.get('state')}")
alerts = [alert["labels"].get("service") for alert in errors.get("alerts", [])]
check(alerts == ["app@file"], f"rule Traefik server errors alerts for {alerts}")
latency = rules.get("Traefik slow responses", {})
check(latency.get("state") == "inactive", f"rule Traefik slow responses is {latency.get('state')}")

print("\n".join(failures))
sys.exit(1 if failures else 0)
EOF

# Poll until every check passes, at most 2 minutes
failures=""
for _ in $(seq 24); do
    # A failed request leaves an unreadable file: the checks fail and the next round retries
    curl -fsS "$metrics/api/v1/targets" > "$directory/targets.json" || true
    curl -sS "$grafana/api/datasources/uid/victoriametrics/health" > "$directory/datasource.json" || true
    curl -sS "$grafana/api/dashboards/uid/traefik" > "$directory/dashboard.json" || true
    curl -fsS "$grafana/api/prometheus/grafana/api/v1/rules" > "$directory/rules.json" || true
    if failures=$(uv run python "$directory/check.py" "$directory"); then
        echo "Vigie provisioned: datasource healthy, dashboard present, alert rules evaluated as expected"
        exit 0
    fi
    sleep 5
done
echo "$failures"
exit 1
