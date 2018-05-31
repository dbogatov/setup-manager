#!/usr/bin/env bash

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

usage() { echo "Usage: $0 [-s <string>]" 1>&2; exit 1; }

SERVICE=""

while getopts "s:" o; do
    case "${o}" in
        s)
            SERVICE=${OPTARG}
        ;;
        *)
            usage
        ;;
    esac
done
shift $((OPTIND-1))

source ./build-services.sh $SERVICE
kubectl apply -R -f ./services/$SERVICE

echo "Done!"
