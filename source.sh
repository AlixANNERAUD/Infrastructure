# Cache the vault password in the private per-user runtime directory (RAM, mode 0700)
if [ -z "$XDG_RUNTIME_DIR" ] || [ ! -O "$XDG_RUNTIME_DIR" ]; then
    echo "XDG_RUNTIME_DIR is not set or not owned by you; refusing to cache the vault password."
    return 1
fi

tmp_vault_file="$XDG_RUNTIME_DIR/ansible_vault_password"

if [ ! -f "$tmp_vault_file" ]; then
    printf "Enter Ansible Vault Password: "
    read -rs vault_pass
    (umask 077 && printf '%s\n' "$vault_pass" > "$tmp_vault_file")
    unset vault_pass
    printf "\nVault password cached in RAM.\n"
fi

# Set your exports
export ANSIBLE_VAULT_PASSWORD_FILE="$tmp_vault_file"
export ANSIBLE_INVENTORY="$(pwd)/inventory.yml"
export EDITOR="zed --wait"

unset tmp_vault_file
echo "Environment variables set for $(pwd)"
