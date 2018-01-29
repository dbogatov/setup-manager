#!/usr/bin/env bash 

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

source ./.secret.sh

curl -s -X DELETE --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/_acme-challenge.$CERTBOT_DOMAIN/TXT

