#!/usr/bin/env bash 

set -e

shopt -s globstar

usage () {
	printf "usage: ./$0 <domain> <value>\n"

	exit 1;
}

if ! [ $# -eq 2 ]
then
	usage
fi

DOMAIN=$1
VALUE=$2

curl -X PUT -d "$VALUE" --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/$DOMAIN/TXT

echo "Done!"
