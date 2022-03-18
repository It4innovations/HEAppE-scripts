#!/bin/bash
pubkey="$1"
temp_file="${HOME}/.ssh/temp_key.pub"
auth_keys_file="${HOME}/.ssh/authorized_keys"
user=$(whoami)

echo "${pubkey}" > ${temp_file} #Put input blob into temporary file
conv_pub_key=$(ssh-keygen -if ${temp_file} | sed "s:ssh-rsa\s::") #Convert input into ssh compatible public key format 
rm -f ${temp_file}

#Check if given ssh public key is in auth_keys file
#if yes, remove entire line containing the key
if grep -q -w "${conv_pub_key}" ${auth_keys_file}; then
	sed -i "\|$conv_pub_key|d" ${auth_keys_file}
	echo "Public key removed for user $user.";
else 
	echo "Public key not found for user $user.";
fi

