#!/usr/bin/env bash 

set -e

shopt -s globstar

REPLICAS="3"

# 
# $1 - service
# $2 - image
# 
generate-service () {

	service=$1
	image=$2
	replicas=$REPLICAS

	echo "Generating $service configs..."

	mkdir -p services/$service

	cp sources/service/{ingress,service,deployment}.yaml services/$service

	if [ "$service" == "legacy-dbogatov-org" ]
	then
		replicas="1"
	fi

	if [ "$service" == "moon-travel-com-ua" ]
	then
		URL="moon-travel.com.ua"
	elif [ "$service" == "veles-russia-com" ]
	then
		URL="veles-russia.com"
	elif [ "$service" == "res-public-net" ]
	then
		URL="res-public.net"
	else
		URL=${service//-/.}
	fi

	docker pull $image > /dev/null
	image=$(docker inspect --format='{{index .RepoDigests 0}}' $image)

	sed -i -e "s#__IMAGE__#$image#g" services/$service/{ingress,service,deployment}.yaml
	sed -i -e "s#__NAME__#$service#g" services/$service/{ingress,service,deployment}.yaml
	sed -i -e "s#__URL__#$URL#g" services/$service/{ingress,service,deployment}.yaml
	sed -i -e "s#__REPLICAS__#$replicas#g" services/$service/{ingress,service,deployment}.yaml

}

source sources/data.sh
source ./.secret.sh

rm -rf services/
mkdir -p services

cp sources/namespace.yaml services/

for service in "${!SERVICES[@]}" 
do
	generate-service $service ${SERVICES[${service}]}
done

for placeholder in "${!PLACEHOLDERS[@]}" 
do
	generate-service $placeholder registry.dbogatov.org/dbogatov/nginx-placeholders/${PLACEHOLDERS[${placeholder}]}:latest
done

### Dashboard OAuth

echo "Dashboard auth configs..."

rm -rf dashboard/
mkdir -p dashboard/dashboard-auth
cp sources/dashboard-auth/*.yaml dashboard/dashboard-auth/

COOKIE_SECRET=$(python -c 'import os,base64; print base64.b64encode(os.urandom(16))')

sed -i -e "s#__OAUTH2_PROXY_COOKIE_SECRET__#$COOKIE_SECRET#g" dashboard/dashboard-auth/oauth2-proxy.yaml
sed -i -e "s#__OAUTH2_PROXY_CLIENT_SECRET__#$OAUTH2_PROXY_CLIENT_SECRET#g" dashboard/dashboard-auth/oauth2-proxy.yaml

DASHBOARD_TOKEN=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') | grep token: )
DASHBOARD_TOKEN="${DASHBOARD_TOKEN:7:${#DASHBOARD_TOKEN}}"

sed -i -e "s#__DASHBOARD_TOKEN__#$DASHBOARD_TOKEN#g" dashboard/dashboard-auth/ingreses.yaml
sed -i -e "s#Bearer      #Bearer #g" dashboard/dashboard-auth/ingreses.yaml

echo "Done!"
