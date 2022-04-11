#!/bin/bash
sshcmdlog="${HOME}/.ssh_command_${USER}.log"
pubkey="$1"
jobid="$2"
temp_file="${HOME}/.ssh/temp_key.pub"
auth_keys_file="${HOME}/.ssh/authorized_keys"

echo "${pubkey}" > ${temp_file} #Put input blob into temporary file
conv_pub_key=$(ssh-keygen -if ${temp_file}) #Convert input into ssh compatible public key format

if [ $? -ne 0  ]; then
	echo "Error when processing input key.";
	exit 1;
fi

# Check if converted key is already present in auth_keys
# if not, add it at the end of the file
if ! grep -q -w "${conv_pub_key}" ${auth_keys_file}; then
	pubkey=$(cat ${temp_file})
	#rm -f ${temp_file}

	keyline="command=\"~/.key_scripts/remote-cmd3.sh ${jobid}\",no-pty,no-port-forwarding,no-agent-forwarding,no-X11-forwarding ${conv_pub_key} key-temp-added-$(date +"%Y-%m-%d_%H-%M-%S")";
	
	#keyline="${conv_pub_key} dhi-temp-added-$(date +"%Y-%m-%d_%H-%M-%S")";
	echo "${keyline}" >> ${auth_keys_file};
	echo "Public key inserted."; 
else
	echo "Public key already present.";
fi

