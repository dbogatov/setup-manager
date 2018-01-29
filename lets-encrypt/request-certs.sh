#!/usr/bin/env bash 

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

source ./domains.sh

REQDOMAINS=$(get-domains)

certbot certonly \
	\
	--text --agree-tos --email dmytro@dbogatov.org \
	--expand --renew-by-default \
	--manual-public-ip-logging-ok \
    \
    --manual \
    --preferred-challenges dns \
	\
	--manual-auth-hook $CWD/authenticator.sh \
	--manual-cleanup-hook $CWD/cleanup.sh \
    \
    -d $REQDOMAINS
