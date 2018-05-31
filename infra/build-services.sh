#!/usr/bin/env bash 

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

REPLICAS="3"

source .secret.sh

#
# $1 - URL
# $2 - name
# $3 - auth
#
generate-ingress () {

	URL=$1
	NAME=$2
	AUTH=$3

	DIR=services/$NAME/ingress

	URLS=()

	if [[ $URL = *dbogatov.org* ]]
	then
		for main in ${MAIN[@]}
		do
			URLS+=(${URL/dbogatov.org/$main})
		done
	else
		URLS+=($URL)
	fi

	for url in ${URLS[@]}
	do
		echo "    - $url" >> $DIR/main.yaml
		echo "    - www.$url" >> $DIR/main.yaml
	done

	for main in ${MAIN[@]}
	do
		echo "    - $NAME.cluster.$main" >> $DIR/main.yaml
	done

	echo "  rules:" >> $DIR/main.yaml

	for url in ${URLS[@]}
	do
		cp $DIR/rule-domain.yaml $DIR/rule-tmp.yaml

		sed -i -e "s#__NAME__#$NAME#g" $DIR/rule-tmp.yaml
		sed -i -e "s#__URL__#$url#g" $DIR/rule-tmp.yaml

		cat $DIR/rule-tmp.yaml >> $DIR/main.yaml
	done

	for main in ${MAIN[@]}
	do
		cp $DIR/rule-cluster.yaml $DIR/rule-tmp.yaml

		sed -i -e "s#__NAME__#$NAME#g" $DIR/rule-tmp.yaml
		sed -i -e "s#__URL__#$main#g" $DIR/rule-tmp.yaml

		cat $DIR/rule-tmp.yaml >> $DIR/main.yaml
	done

	cp $DIR/main.yaml $DIR/../ingress.yaml

	sed -i -e "s#__AUTH__#$AUTH#g" $DIR/../ingress.yaml
	sed -i -e "s#__NAME__#$NAME#g" $DIR/../ingress.yaml

	sed -i -e '/^\s*$/d' $DIR/../ingress.yaml

	rm -r $DIR
}

# 
# $1 - service
# $2 - image
# 
generate-service () {

	service=$1
	image=$2
	replicas=$REPLICAS
	auth=""

	echo "Generating $service configs..."

	mkdir -p services/$service/ingress

	cp sources/service/{service,deployment}.yaml services/$service
	cp sources/service/ingress/{main,rule-*}.yaml services/$service/ingress

	if [ "$service" == "webcam-dbogatov-org" ]
	then
		auth="ingress.kubernetes.io/auth-type: basic"
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

	creds="--creds=dbogatov:$DOCKERPASS"
	if [[ $image = *"registry.hub.docker.com"* ]]; then
		creds=""
	fi
	digest=$(skopeo inspect $creds docker://$image  | jq '.Digest')
	digest="${digest%\"}"
	digest="${digest#\"}"
	image=${image%:*}@$digest

	sed -i -e "s#__IMAGE__#$image#g" services/$service/{service,deployment}.yaml
	sed -i -e "s#__NAME__#$service#g" services/$service/{service,deployment}.yaml
	sed -i -e "s#__URL__#$URL#g" services/$service/{service,deployment}.yaml
	sed -i -e "s#__REPLICAS__#$replicas#g" services/$service/{service,deployment}.yaml
	sed -i -e "s#__AUTH__#$auth#g" services/$service/{service,deployment}.yaml

	generate-ingress "$URL" "$service" "$auth"

	if [ "$service" == "shevastream-com" ]
	then
		cat sources/shevastream/deployment.yaml >> services/$service/deployment.yaml
	fi
}

source sources/data.sh
source ./.secret.sh

rm -rf services/
mkdir -p services

cp sources/namespace.yaml services/

if [ -n "$1" ]
then
	generate-service $1 ${SERVICES[${1}]}
else
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
fi

echo "Done!"
