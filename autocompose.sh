#!/bin/bash

# This script makes use of [Auto-Compose](https://github.com/Red5d/docker-autocompose)
# Auto-Compose is not updated and may generate mistakes, but is generally helpful in converting running containers to compose files

help() {
cat << EOF
    Use: autocompose.sh [options] [container_names]
    This script creates a compose.yml file from running Docker containers using AutoCompose by Red5d

    Options:
        -a      Auto-Compose all containers
        -f      Specify compose file path and name
        -h      Display this help dialog
        
    AutoCompose source code: https://github.com/Red5d/docker-autocompose
EOF
}

# No arguments
if [ -z "$1" ]; then help; exit 1; fi

# Options
## Defaults
file=compose.auto.yml
## Flags
while getopts "af:h" opt; do
    case ${opt} in
        a ) all=true ;;
        f ) file=$OPTARG ;;
        h ) help; exit 2 ;;
        ? ) help; exit 1 ;;
    esac
done
shift "$((OPTIND-1))"

# Selected containers to auto-compose
containers=$@
[ ! -z $all ] && containers=$(docker ps -aq)

# Run autocompose
docker run --rm --name autocompose \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ghcr.io/red5d/docker-autocompose $containers > $file