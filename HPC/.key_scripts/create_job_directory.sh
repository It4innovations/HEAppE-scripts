#!/bin/bash
storage_path="$1"
heappe_execution_dir="$2"
job_execution_dir="$3"
shared_accounts_pool_mode="${4:-false}"

acl="700" # Default ACL
if "${shared_accounts_pool_mode}"; then
    acl="750"
fi

current_base_path="${storage_path}/${heappe_execution_dir}"
if [ ! -d "${current_base_path}" ]; then
     mkdir -p "${current_base_path}"
     chmod -R 770 "${storage_path}/${heappe_execution_dir%%/*}"
fi

current_dir="${current_base_path}/${job_execution_dir}"
if mkdir -m "${acl}" -p "${current_dir}"; then
    echo "Created directory $current_dir with ACL $acl."
    exit 0
else
    echo "Cannot create directory $current_dir."
    exit 1
fi