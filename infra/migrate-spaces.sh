#!/usr/bin/env bash

# Files in ./terraform/spaces/ must be <from> and <to>
# and must contain configs to connect to those buckets
# generated with `s3cmd --configure`

set -e

shopt -s globstar

# Ensure that the CWD is set to script's location
cd "${0%/*}"
CWD=$(pwd)

TEMP_DIR="spaces-buffer"

usage () {
	printf "usage: $0 <from> <to> <last-gitlab-backup>\n"

	exit 1;
}

if ! [ $# -eq 3 ]
then
	usage
fi

FROM=$1
TO=$2
GITLAB=$3

rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

cd $TEMP_DIR

mkdir -p public

s3cmd -c ../terraform/spaces/$FROM get s3://$FROM/public/ --recursive public
s3cmd -c ../terraform/spaces/$TO put public s3://$TO --recursive

s3cmd -c ../terraform/spaces/$FROM get s3://$FROM/$GITLAB --recursive
s3cmd -c ../terraform/spaces/$TO put $GITLAB s3://$TO --recursive

cd $CWD

rm -rf $TEMP_DIR

echo "Done."
