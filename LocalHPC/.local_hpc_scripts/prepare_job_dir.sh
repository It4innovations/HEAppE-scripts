#!/bin/bash
cd "$1" || exit
touch .job_info
BASE64_TEXT=$2
COMMANDS=$3
JSON=$(echo "${BASE64_TEXT}" | base64 -d)
echo "$JSON" > .job_info
echo "$COMMANDS" > .commands