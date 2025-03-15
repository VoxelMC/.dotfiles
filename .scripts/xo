#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "You must enter 1 or more command line arguments";
elif [ "$#" -eq 1 ]; then
	xdg-open "$1" 
else
	for file in "$@"; do
	  xdg-open "$file" 
	done
fi
