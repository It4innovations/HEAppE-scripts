#!/bin/bash
auth_keys_file="${HOME}/.ssh/authorized_keys"
pubkey=$(echo "$1" | base64 -d)
jobid="$2"

keyline="command=\"~/.key_scripts/remote-cmd3.sh ${jobid}\",no-pty,no-port-forwarding,no-agent-forwarding,no-X11-forwarding ${pubkey}";

echo "${keyline}" >> "${auth_keys_file}";
echo "Public key '${pubkey}' inserted.";