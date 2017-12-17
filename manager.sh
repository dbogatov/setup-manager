#!/usr/bin/env bash 

curl -L -o websites.yml https://git.dbogatov.org/dbogatov/Setup-Manager/-/jobs/artifacts/master/raw/websites.yml?job=deploy

curl -L -o status.yml https://git.dbogatov.org/dbogatov/status-site/-/jobs/artifacts/master/raw/docker-compose.yml?job=release-app-docs

# docker stack rm websites

docker stack deploy --with-registry-auth --compose-file websites.yml websites
