#!/bin/bash

# Check input
if [ -z "$1" ]; then
    echo No log file selected
    exit 1
elif [ ! -f "$1" ]; then
    echo "$1" is not a file
    exit 1
fi

# Container name
if [ ! -z "$2" ]; then
    container=$2
else
    container=$(basename "$1")
fi

# Start tracking container
docker run -dth "$container" -v "$1:/log/log.log:ro" --name "$container" alpine sh -c "cat /log/log.log; tail -f /log/log.log"