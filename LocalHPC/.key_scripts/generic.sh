#!/bin/bash
# shellcheck source=./test.sh
USER_SCRIPT="$1"
PARAMETERS="$2"

# Expand parameter pairs for this script.
case ${PARAMETERS} in
    (*=*) eval "${PARAMETERS}";
esac

# Source the user script here. We can't just eval or call it, because we would lose the expanded parameters.
. "${USER_SCRIPT}"