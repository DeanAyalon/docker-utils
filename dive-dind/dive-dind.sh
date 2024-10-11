#!/bin/bash

help() { cat help.txt; }

# SCRIPT EXECUTION

# Context
cd "$(dirname "$0")"

[ -z "$1" ] && help && exit 1
case "$1" in
    # docker save, docker cp, docker exec docker import
    local ) 
        echo local ;;
    
    # docker compose down -v
    clean ) 
        docker compose down -v ; exit ;;
esac

echo penis