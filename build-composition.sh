#!/usr/bin/env bash

set -e

source data.sh

FILENAME="websites.yml"

# 
# 1 - name
# 2 - image
# 
build-regular-service-block () {

		cat >> $FILENAME <<EOLREGULAR
  $1:
    image: $2
    deploy:
      restart_policy:
        condition: on-failure
    networks:
      - internal

EOLREGULAR

}

build-nginx-service-block () {

		cat >> $FILENAME <<EOLNGINX
  nginx:
    image: registry.dbogatov.org/dbogatov/nginx-config:latest
    ports:
      - "80:80"
      - "443:443"
    deploy:
      placement:
        constraints:
          - node.role == manager
    volumes:
      - type: bind
        source: /etc/letsencrypt/
        target: /etc/letsencrypt/
        readonly: true
      - type: bind
        source: /etc/ssl/certs/dhparam.pem
        target: /etc/ssl/certs/dhparam.pem
        readonly: true
    networks:
      - internal

EOLNGINX

}

build-networks-block () {

		cat >> $FILENAME <<EOLNETWORKS
networks:
  $NETWORK:
    driver: overlay

EOLNETWORKS

}

build-init () {

	cat > $FILENAME <<'_EOF'
version: "3.3"

services:

_EOF

}

rm -f $FILENAME
touch $FILENAME

build-init

build-nginx-service-block

for service in "${!SERVICES[@]}" 
do
	build-regular-service-block $service ${SERVICES[${service}]}
done

build-networks-block
