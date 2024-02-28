#!/bin/bash
# Copy job data to temp directory according to cluster basepath
sourcepath="$1"
destinationpath="$2"

mkdir -p "${destinationpath}"
	
if [ -d "${sourcepath}" ]; then
	cp -Tr "${sourcepath}" "${destinationpath}"
	echo "Files from ${sourcepath} were copied to temporary directory ${destinationpath}."
else
	cp "${sourcepath}" "${destinationpath}"
	echo "File ${sourcepath} was copied to temporary directory ${destinationpath}."
fi