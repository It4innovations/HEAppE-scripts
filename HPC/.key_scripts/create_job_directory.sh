#!/bin/bash
# Create job directory according to cluster basepath
jobdir="$1"
if [ -d "${jobdir}" ]; then
	echo "Job directory ${jobdir} already exists.";
else
	if mkdir -m 700 "${jobdir}"; then
		echo "Created directory ${jobdir}."					
	else
		echo "Cannot create directory ${jobdir}."
	fi
fi