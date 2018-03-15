#!/usr/bin/env bash 

set -e

shopt -s globstar

usage () {
	printf "usage: ./$0 <certDirPath>\n"
	printf "where\n"
	printf "\t certDirPath - absolute path to directory with SSL cert (certificate.crt) and key (certificate.key) file\n"

	exit 1;
}

if ! [ $# -eq 1 ]
then
	usage
fi

CERTDIRPATH=$1

NAMESPACES=("websites" "monitoring" "ingress" "status-site" "kube-system")

for namespace in ${NAMESPACES[@]}
do
	kubectl delete --namespace=$namespace secret lets-encrypt || true
	kubectl create --namespace=$namespace secret tls lets-encrypt --key $CERTDIRPATH/certificate.key --cert $CERTDIRPATH/certificate.crt || true
done

echo "Done."
