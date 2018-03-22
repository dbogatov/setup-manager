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

FILES=("certificate.key" "certificate.crt")

for file in ${FILES[@]}
do
	scp $CERTDIRPATH/$file git.dbogatov.org:/home/dbogatov/certs/
done

echo "Done."
