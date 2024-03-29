#!/bin/sh
sshcmdlog="${HOME}/.ssh_command_${USER}.log"
cmd="$SSH_ORIGINAL_COMMAND"
baseprefixpath="TODO"
basepath="${baseprefixpath}/${1}"

echo "$(date) ($SSH_CLIENT): $cmd" >> "$sshcmdlog"
echo "$cmd" | grep -E '\.{2}|\&|;|\|' > /dev/null && echo "Forbidden command (regex): $cmd" >> "$sshcmdlog" && exit
echo "$cmd" | grep -F -v "${basepath}" > /dev/null && echo "Forbidden path: $cmd" >> "$sshcmdlog" && exit

case "${cmd%% *}" in
  ls)
        ls ${cmd#*ls}
        ;;
  scp)
        scp ${cmd#*scp}
        ;;
  mkdir)
        mkdir ${cmd#*mkdir}
        ;;
  rsync)
        rsync ${cmd#*rsync}
        ;;
  "")
        echo "Empty command." >> "$sshcmdlog"
        ;;
  *)
        echo "Forbidden command: $cmd"  >> "$sshcmdlog"
        ;;
esac