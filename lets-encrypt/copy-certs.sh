#!/usr/bin/env bash 

set -e

shopt -s globstar

usage () {
	printf "usage: ./$0 <certDirPath> <certName>\n"
	printf "where\n"
	printf "\t certDirPath - absolute path to directory with SSL cert (certificate.crt) and key (certificate.key) file\n"
	printf "\t certName - xxx part of /etc/letsencrypt/live/xxx/fullchain.pem\n"

	exit 1;
}

if ! [ $# -eq 2 ]
then
	usage
fi

CERTDIRPATH=$1
CERTNAME=$2

cp /etc/letsencrypt/live/$CERTNAME/fullchain.pem $CERTDIRPATH/certificate.crt
cp /etc/letsencrypt/live/$CERTNAME/privkey.pem $CERTDIRPATH/certificate.key

echo "Done."
