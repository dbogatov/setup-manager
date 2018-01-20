#!/usr/bin/env bash 

set -e

shopt -s globstar

source sources/data.sh

for service in "${!SERVICES[@]}" 
do
	echo "Testing $service..."

	curl -I $service.cluster.dbogatov.org
done

echo "Done!"
