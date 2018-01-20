#!/usr/bin/env bash 

set -e

shopt -s globstar

source sources/data.sh

rm -rf services/
mkdir -p services

cp sources/namespace.yaml services/

for service in "${!SERVICES[@]}" 
do
	echo "Generating $service configs..."

	mkdir -p services/$service

	cp sources/{ingress,service,deployment}.yaml services/$service

	sed -i '' -e "s/__NAME__/$service/g" services/$service/{ingress,service,deployment}.yaml
	sed -i '' -e "s#__IMAGE__#${SERVICES[${service}]}#g" services/$service/{ingress,service,deployment}.yaml
done

echo "Done!"
