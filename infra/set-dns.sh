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

	VALUES=($(dig +short A ${DOMAINS[${domain}]}))

	echo "Removing A records for $domain, *.$domain and www.$domain"

	curl -X DELETE --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/$domain/A
	curl -X DELETE --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/www.$domain/A
	curl -X DELETE --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/*.$domain/A

	for value in ${VALUES[@]}
	do

		echo "Setting A record value $value for $domain, *.$domain and www.$domain"

		curl -X POST -d "$value" --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/$domain/A
		curl -X POST -d "$value" --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/www.$domain/A
		curl -X POST -d "$value" --user $EMAIL:$PASSWORD https://box.dbogatov.org/admin/dns/custom/*.$domain/A

	done

done

echo "Done!"
