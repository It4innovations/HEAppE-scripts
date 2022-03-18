#!/bin/bash
echo "Cancel job..."

BASE_DIR=$(<~/.local_hpc_scripts/.heappeWorkDirInfo)
JOB_DIR=$1
cd "${BASE_DIR}${JOB_DIR}" || exit

PID=$(cat .job_info | jq '.Pid')

kill "$PID"

TIME=$(date -u +"%FT%T.000Z")
A=$(jq --arg t "${TIME}" '.EndTime = $t' .job_info)
echo "$A" > .job_info

A=$(jq --arg t "${TIME}" '.StartTime = $t' .job_info)
echo "$A" > .job_info

STATE="S"
A=$(jq --arg s "${STATE}" '.State = $s' .job_info)
echo "$A" > .job_info

TASK_COUNT=$(cat .job_info | jq  '.Tasks' | jq length)

((TASK_COUNT-=1))

for i in $(seq 0 $TASK_COUNT)
do
	A=$(jq --argjson i "${i}" '.Tasks[$i].State = "S"' .job_info)
	echo "$A" > .job_info
	START_TIME=$(cat .job_info | jq -r --argjson i "${i}" '.Tasks[$i].StartTime' )
	
	A=$(jq --argjson i "${i}"	--arg t "${TIME}"	'.Tasks[$i].EndTime = $t' .job_info)
	echo "$A" > .job_info
	
	END=$(date -d "${TIME}" "+%s" )
	N="null"
	
	if [ "$START_TIME" == "$N" ];
	then
      		ALLOCATED_TIME=$(($END-$START))
	else
      		START=$(date -d "${START_TIME}" "+%s" )
		ALLOCATED_TIME=$(($END-$START))
	fi
	
	A=$(jq 	--argjson i "${i}"	--argjson s "${ALLOCATED_TIME}"	'.Tasks[$i].AllocatedTime = $s' .job_info)
	echo "$A" > .job_info

done