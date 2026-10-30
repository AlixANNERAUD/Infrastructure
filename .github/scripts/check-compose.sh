#!/usr/bin/env bash
# Validate every Compose file, with placeholder values for the variables
# that Ansible writes to .env at deploy time.
set -euo pipefail

status=0
for file in services/*/compose.yml; do
    env_file=$(mktemp)
    { grep -oE '\$\{[A-Za-z_][A-Za-z0-9_]*' "$file" || true; } | cut -c3- | sort -u | while read -r name; do
        case "$name" in
            *PORT | *_ID) echo "$name=1000" ;;
            *PATH) echo "$name=/placeholder" ;;
            *_PROXIES) echo "$name=127.0.0.1/32" ;;
            *_PUBLISH) echo "$name=8448:8448" ;;
            *) echo "$name=placeholder" ;;
        esac
    done > "$env_file"

    if docker compose --env-file "$env_file" -f "$file" config --quiet; then
        echo "ok    $file"
    else
        echo "error $file"
        status=1
    fi
    rm -f "$env_file"
done
exit "$status"
