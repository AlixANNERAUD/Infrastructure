local tmp_vault_file="/dev/shm/.ansible_vault_$(whoami)"

if [ ! -f "$tmp_vault_file" ]; then
    echo -n "Enter Ansible Vault Password: "
    read -s vault_pass
    echo "$vault_pass" > "$tmp_vault_file"
    chmod 600 "$tmp_vault_file"
    echo -e "\nVault password cached in RAM."
fi

# Set your exports
export ANSIBLE_VAULT_PASSWORD_FILE="$tmp_vault_file"
export ANSIBLE_INVENTORY="$(pwd)/inventory.yml"
export EDITOR="codium --wait"

echo "Environment variables set for $(pwd)"
