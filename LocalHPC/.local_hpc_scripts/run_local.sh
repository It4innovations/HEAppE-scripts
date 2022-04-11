#!/bin/bash
echo "Runnig script..."
JOB_DIR=$1
cd "$JOB_DIR" || exit

ALL_COMMANDS=$(<.commands)
TASK_COMMANDS=("$ALL_COMMANDS")

JOB_ID=$(basename "$1")

#START JOB - WRITE INFO
TIME=$(date -u +"%FT%T")
A=$(jq --arg t "${TIME}" '.SubmitTime = $t' .job_info) && echo "$A" > .job_info

A=$(jq --arg t "${TIME}" '.StartTime = $t' .job_info) && echo "$A" > .job_info

STATE="R"
A=$(jq --arg s "${STATE}" '.State = $s' .job_info) && echo "$A" > .job_info

PID=$$
A=$(jq --argjson s "${PID}" '.Pid = $s' .job_info) && echo "$A" > .job_info
echo "$@"

TASK_ORDER=0
for task in "$@"
do
	#echo $task
	if [ "$task" = "$JOB_DIR" ]; then
		continue
	fi
	TASK_DIR="${JOB_DIR}${task}"
	#echo $TASK_DIR
	cd "$TASK_DIR" || exit
	A=$(jq --argjson o "${TASK_ORDER}" --argjson j "${JOB_ID}"	'.Tasks[$o].JobId = $j' ../.job_info) && echo "$A" > ../.job_info
	
	A=$(jq --argjson o "${TASK_ORDER}" '.Tasks[$o].State = "R"' ../.job_info) && echo "$A" > ../.job_info
	SECONDS=0
	
	TIME=$(date -u +"%FT%T.000Z")
	A=$(jq --argjson o "${TASK_ORDER}"	--arg t "${TIME}"	'.Tasks[$o].StartTime = $t' ../.job_info) && echo "$A" > ../.job_info
	
	JOB_ARRAYS=$(jq -r --argjson o "${TASK_ORDER}" '.Tasks[$o].JobArrays' ../.job_info)
	
	BASE64_COMMAND=${TASK_COMMANDS[TASK_ORDER]}
	
	#TEST TASK DEPENDENCY
	DEPENDS_ON=$(jq -r --argjson o "${TASK_ORDER}" '.Tasks[$o].DependsOn' ../.job_info)

	DEPENDS_ON_OK=true
	if [ "${DEPENDS_ON}" != "null" ]
	then
		for id in $(echo "$DEPENDS_ON" | tr "," "\n")
		do
			STATE_DEPENDED=$( jq -r --argjson id "${id}" '.Tasks[] | select(.Id == $id) | .State' ../.job_info)
			if [ "$STATE_DEPENDED" != "F" ]
			then
				TASK_STATE="S" #Cancel
				DEPENDS_ON_OK=false
				break
			fi
		done
	fi	
	
	if [ $DEPENDS_ON_OK == true ]
	then
		#RUN SIMPLE TASK OR JOB ARRAYS
		if [ "${JOB_ARRAYS}" = "null" ]
		then
			~/.key_scripts/run_command.sh  "$BASE64_COMMAND"
		else
			jobArraysParsed=($(echo "$JOB_ARRAYS" | tr '-' ' ' | tr ':' ' ' ))
			if [ ${#jobArraysParsed[@]} -eq 2 ]
			then
				skip=1
			else
				skip=${jobArraysParsed[2]}
			fi
			LLHPC_ARRAY_INDEX=-1
			for i in $(eval echo "{${jobArraysParsed[0]}..${jobArraysParsed[1]}..${skip}}")
			do
				echo "Running JobArray iteration: ${i}"
				export LLHPC_ARRAY_INDEX=$i
				~/.key_scripts/run_command.sh  "$BASE64_COMMAND"
			done
		fi
		
		#CHECK STATE		
		if [ $? -ne 0 ]
		then
			TASK_STATE="O" #failed
		else
			TASK_STATE="F" #finished
		fi		
	fi
	
	TIME=$(date -u +"%FT%T.000Z")
	STOP_TIMER_SECONDS=$SECONDS
	A=$(jq --argjson o "${TASK_ORDER}"	--arg t "${TIME}"	'.Tasks[$o].EndTime = $t' ../.job_info) && echo "$A" > ../.job_info
	
	A=$(jq 	--argjson o "${TASK_ORDER}"	--argjson s "${STOP_TIMER_SECONDS}"	'.Tasks[$o].AllocatedTime = $s' ../.job_info) && echo "$A" > ../.job_info
	
	A=$(jq --argjson o "${TASK_ORDER}"	--arg s "${TASK_STATE}" '.Tasks[$o].State = $s' ../.job_info) && echo "$A" > ../.job_info
	
	((TASK_ORDER+=1))
done

cd "$JOB_DIR" || exit

TIME=$(date -u +"%FT%T")
A=$(jq --arg t "${TIME}" '.EndTime = $t' .job_info) && echo "$A" > .job_info
STATE="F"
A=$(jq --arg s "${STATE}" '.State = $s' .job_info) && echo "$A" > .job_info

echo 'Job finished!'