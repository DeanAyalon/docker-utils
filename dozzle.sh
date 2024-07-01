#!/bin/bash

# Help
help() {
    echo "Use: dozzle.sh [options]"
    echo Options:
    echo "  -h      Display this help dialog"
    echo "  -o      Start Dozzle and open it in browser"
    echo "  -O      Open Dozzle in browser"
    echo "  -s      Stop dozzle"
    echo "  -w      Watch log file"
}

open_dozzle() {
    # Check Dozzle
    if [ -z "$(docker ps -q --filter name=dozzle)" ]; then
        echo Dozzle is down
        exit 1
    fi

    # TODO: open by OS
    if [ $(uname) = "Darwin" ]; then
        open $url
    else
        echo OS not yet supported, please manually open this url:
        echo $url
    fi
}

# Constants
url=http://localhost:9999

# SCRIPT EXECUTION

# Options
while getopts "hoOsw:" opt; do
    case ${opt} in
        h ) help; exit 2 ;;

        o ) open=true ;;
        O ) open_dozzle; exit 0 ;;

        # Stop
        s ) cd $(dirname "$0")
            docker compose down dozzle
            exit 0 
            ;;

        # Watch - alpine container tailing specified file
        w ) container=$(basename "$OPTARG")
            echo Starting container $container to watch $OPTARG
            docker run -dth "$container" --name $container \
                -v "$OPTARG:/log:ro" alpine \
                sh -c "cat /log; tail -f /log" 
            ;;

        ? ) help; exit 1 ;; # Wrong input
    esac
done
shift "$((OPTIND-1))"

cd "$(dirname "$0")"
docker compose up -d dozzle

[ -z $open ] || open_dozzle