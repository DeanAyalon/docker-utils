#!/bin/bash

# This script makes use [Auto-Compose]()
# Auto-Compose is not updated and may generate mistakes, but is generally helpful in converting running containers to compose files

help() {
    # echo Use: "$0" [options] [container_names]
    echo Use: autocompose [options] [container_names]
    echo This script creates a compose.yml file from running Docker containers
    echo 
    echo Options:
    echo "  -a      Auto-Compose all containers"
    echo "  -f      Specify compose file path and name"
    echo "  -h      Display this help dialog"
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