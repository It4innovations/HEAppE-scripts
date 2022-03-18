#!/bin/bash
BASE_DIR=$(<~/.local_hpc_scripts/.heappeWorkDirInfo)
ls "$BASE_DIR" | wc -l