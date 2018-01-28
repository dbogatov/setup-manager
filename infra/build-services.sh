#!/usr/bin/env bash 

set -e

shopt -s globstar

source sources/data.sh
source ./.secret.sh

rm -rf services/
mkdir -p services

cp sources/namespace.yaml services/

for service in "${!SERVICES[@]}" 
do
	echo "Generating $service configs..."

	mkdir -p services/$service

	cp sources/service/{ingress,service,deployment}.yaml services/$service

	sed -i '' -e "s#__NAME__#$service#g" services/$service/{ingress,service,deployment}.yaml
	sed -i '' -e "s#__IMAGE__#${SERVICES[${service}]}#g" services/$service/{ingress,service,deployment}.yaml
done

### Dashboard OAuth

echo "Dashboard auth configs..."

mkdir -p services/dashboard-auth
cp sources/dashboard-auth/*.yaml services/dashboard-auth/

COOKIE_SECRET=$(python -c 'import os,base64; print base64.b64encode(os.urandom(16))')

sed -i '' -e "s#__OAUTH2_PROXY_COOKIE_SECRET__#$COOKIE_SECRET#g" services/dashboard-auth/oauth2-proxy.yaml
sed -i '' -e "s#__OAUTH2_PROXY_CLIENT_SECRET__#$OAUTH2_PROXY_CLIENT_SECRET#g" services/dashboard-auth/oauth2-proxy.yaml

DASHBOARD_TOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep token: )
DASHBOARD_TOKEN="${DASHBOARD_TOKEN:7:${#DASHBOARD_TOKEN}}"

sed -i '' -e "s#__DASHBOARD_TOKEN__#$DASHBOARD_TOKEN#g" services/dashboard-auth/ingreses.yaml
sed -i '' -e "s#Bearer      #Bearer #g" services/dashboard-auth/ingreses.yaml

echo "Done!"
