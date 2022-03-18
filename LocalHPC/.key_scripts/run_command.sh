#!/bin/bash
BASE64_TEXT=$1

#echo "${BASE64_TEXT}"
COMMAND=$(echo "${BASE64_TEXT}" | base64 -d)
#echo "${COMMAND}"
eval "${COMMAND}"