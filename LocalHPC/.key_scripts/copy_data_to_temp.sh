#!/bin/bash
# Copy job data to temp directory according to cluster basepath
sourcepath="$1"
destinationpath="$2"
hpcprojectid="TODO"

if [ -d ${sourcepath} ]; then
	cp -Tr ${sourcepath} ${destinationpath}
	echo "Files from ${sourcepath} were copied to temporary directory ${destinationpath}."
	for i in {01..05}; do setfacl -R -m u:${hpcprojectid}-$i:rwx ${destinationpath}; done
	echo "Permissions were set for temporary directory ${destinationpath}."
else
	if [ ! -d ${destinationpath} ]; then
		mkdir ${destinationpath}
	fi
	cp ${sourcepath} ${destinationpath}
	echo "File ${sourcepath} was copied to temporary directory ${destinationpath}."
	for i in {01..05}; do setfacl -R -m u:${hpcprojectid}-$i:rwx ${destinationpath}; done
	echo "Permissions were set for temporary directory ${destinationpath}."
fi
