#!/usr/bin/env bash 

set -e

# shopt -s globstar

source sources/data.sh

usage () {
	printf "usage: ./$0 <email> <password>\n"

	exit 1;
}

if ! [ $# -eq 2 ]
then
	usage
fi

EMAIL=$1
PASSWORD=$2

for domain in "${!DOMAINS[@]}" 
do
	echo "Setting $domain..."

	curl -X PUT -d "${DOMAINS[${domain}]}" --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/$domain/A
	curl -X PUT -d "${DOMAINS[${domain}]}" --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/www.$domain/A
	curl -X PUT -d "${DOMAINS[${domain}]}" --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/*.$domain/A

	curl -X DELETE --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/$domain/CNAME
	curl -X DELETE --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/www.$domain/CNAME
	curl -X DELETE --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/*.$domain/CNAME

done

echo "Done!"
