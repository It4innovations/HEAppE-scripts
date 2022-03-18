#!/bin/bash
# Copy temp data to job directory according to cluster basepath
sourcepath="$1"
destinationpath="$2"

if [ ! -d ${destinationpath} ]; then
	echo "Destination directory ${destinationpath} does not exist.";
else
	cp -r ${sourcepath} ${destinationpath}
	echo "Data from temp directory ${sourcepath} were copied to job directory ${destinationpath}."
fi
