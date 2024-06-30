#!/bin/bash
    
# Show running containers on error
running_containers() {
    docker ps --format "{{.Names}}"
}
err() {
    [ ! -z "$1" ] && echo $1        # Error Message
    echo Running containers:
    running_containers | awk '{print "- " $0}'
    exit 1
}

# Check if a container name was provided
[ -z "$1" ] && err "Please provide a container name"

# Use the provided container name
CONTAINER_NAME=$1
running_containers | grep $CONTAINER_NAME > /dev/null || err "$CONTAINER_NAME not found"

# Define shell
SHELL=$2
[ -z $SHELL ] && SHELL=bash

# Enter the container
docker exec -itu 0 $CONTAINER_NAME /bin/$SHELL && exit 0
                                        # Adding > /dev/null freezes when trying to enter dean-nginx, why?

# Try different shells if failed
if [ $SHELL != bash ]; then
    echo Failed to enter using $SHELL, trying bash
    docker exec -itu 0 $CONTAINER_NAME /bin/bash && exit 0
fi
if [ $SHELL != sh ]; then
    echo Failed to enter using bash, trying sh
    docker exec -itu 0 $CONTAINER_NAME /bin/sh && exit 0
fi

# Failed
err "Failed to enter $CONTAINER_NAME"