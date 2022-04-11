#!/bin/sh
sshcmdlog="${HOME}/.ssh_command_${USER}.log"
cmd="$SSH_ORIGINAL_COMMAND"
baseprefixpath="TODO"
basepath="${baseprefixpath}/${1}"

echo "`date` ($SSH_CLIENT): $cmd" >> $sshcmdlog
echo "$cmd" | grep -E '\.{2}|\&|\|' > /dev/null && echo "Forbidden command (regex): $cmd" >> $sshcmdlog && exit
echo "$cmd" | fgrep -v ${basepath} > /dev/null && echo "Forbidden path: $cmd" >> $sshcmdlog && exit
#eval $cmd
case "$cmd" in
   scp*|ls*|mkdir*)
        eval $cmd
        ;;
  *)
        echo "Forbidden command: $cmd" >> $sshcmdlog
        ;;
  "")
        echo "Empty command." >> $sshcmdlog
        ;;
esac

