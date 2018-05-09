#!/usr/bin/env bash 

set -e

shopt -s globstar

declare -A DOMAINS

# Value means expected code

SUCCESS="200"
PERMANENT_REDIRECT="301"
FOUND="302"
SERVICE_UNABAILBALE="503"

MAIN=("dbogatov.org" "dmytro.app" "bogatov.app")

DOMAINS["__MAIN__"]=$SUCCESS
DOMAINS["status.__MAIN__"]=$SERVICE_UNABAILBALE
DOMAINS["blog.__MAIN__"]=$SUCCESS
DOMAINS["legacy.__MAIN__"]=$SUCCESS
DOMAINS["push.__MAIN__"]=$SUCCESS
DOMAINS["socialimps.__MAIN__"]=$SUCCESS
DOMAINS["mail.__MAIN__"]=$SUCCESS
DOMAINS["dns.__MAIN__"]=$SUCCESS


DOMAINS["dashboard.dbogatov.org"]=$FOUND

DOMAINS["bogatov.kiev.ua"]=$SUCCESS
DOMAINS["blog.bogatov.kiev.ua"]=$SUCCESS

DOMAINS["visasupport.com.ua"]=$SUCCESS
DOMAINS["zima.visasupport.com.ua"]=$SUCCESS

DOMAINS["visasupport.kiev.ua"]=$SUCCESS
DOMAINS["eu.visasupport.kiev.ua"]=$SUCCESS
DOMAINS["lp.visasupport.kiev.ua"]=$SUCCESS

DOMAINS["darinagulley.com"]=$SUCCESS

DOMAINS["moon-travel.com.ua"]=$PERMANENT_REDIRECT

DOMAINS["nigmatullina.org"]=$SUCCESS

DOMAINS["photobarrat.com"]=$SUCCESS

DOMAINS["shevastream.com/home"]=$SUCCESS

DOMAINS["travelus.com.ua"]=$SUCCESS

DOMAINS["veles-russia.com"]=$SUCCESS

DOMAINS["visajapan.com.ua"]=$SUCCESS

DOMAINS["vleskniga.com"]=$SUCCESS

PASSED=true

for domain in "${!DOMAINS[@]}" 
do
	URLS=()

	if [[ $domain = *"__MAIN__"* ]]
	then
		for main in ${MAIN[@]}
		do
			URLS+=(${domain/__MAIN__/$main})
		done
	else
		URLS+=($domain)
	fi

	for url in ${URLS[@]}
	do
		code=$(curl -s -o /dev/null -I -w "%{http_code}" https://$url)

		if [ $code == "${DOMAINS[${domain}]}" ]
		then
			RESULT="PASS"
		else
			RESULT="FAIL"
			PASSED=false
		fi

		echo "$RESULT ($code) : $url"
	done
done

echo "Tests complete."

if [ $PASSED == true ]
then
	echo "All tests passed!"
	exit 0
else
	echo "Some tests failed..."
	exit 1
fi
