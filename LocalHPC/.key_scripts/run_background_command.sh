#!/bin/bash

# Run a command in the background.
_evalBg() {
    eval "$@" &>/dev/null & disown;
}


BASE64_TEXT=$1

#echo "${BASE64_TEXT}"
COMMAND=$(echo "${BASE64_TEXT}" | base64 -d)
#echo "${COMMAND}"

_evalBg "${COMMAND}";