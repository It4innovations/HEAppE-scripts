#!/bin/bash
#HEAPPE_PARAM iterations
#HEAPPE_PARAM message

echo "Input param: ${message}"
for i in $( eval echo "{0..${iterations}}" )
do
	echo "Iteration: ${i}"
	sleep 30s
done
echo "some result" >> resultFile.txt
