#!/bin/bash
inputParam="$1"
echo "Input param: ${inputParam}"
for i in {01..10} 
do 
	echo "Iteration: ${i}"
	sleep 30s
done
echo "some result" >> resultFile.txt
