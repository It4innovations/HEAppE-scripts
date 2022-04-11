#!/bin/bash
BASE_DIR=$(<~/.local_hpc_scripts/.heappeWorkDirInfo)
JOB_DIR=$1
cd "${BASE_DIR}${JOB_DIR}" || exit
cat .job_info