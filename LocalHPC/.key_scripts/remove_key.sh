#!/bin/bash
pubkey=$(echo "$1" | base64 -d)
auth_keys_file="${HOME}/.ssh/authorized_keys"
user=$(whoami)

#Check if given ssh public key is in auth_keys file
#if yes, remove entire line containing the key
if grep -q -w "$pubkey" "${auth_keys_file}"; then
        sed -i "\|$pubkey|d" "${auth_keys_file}"
        echo "Public key '${pubkey}' removed for user '${user}'.";
else
        echo "Public key '${pubkey}' not found for user '${user}'.";
fi