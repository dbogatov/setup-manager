#!/usr/bin/env bash

declare -A DOMAINS

DOMAINS["dbogatov.org"]=true
DOMAINS["cluster.dbogatov.org"]=true

DOMAINS["bogatov.kiev.ua"]=true
DOMAINS["visasupport.com.ua"]=true
DOMAINS["visasupport.kiev.ua"]=true
DOMAINS["darinagulley.com"]=true
DOMAINS["moon-travel.com.ua"]=true
DOMAINS["nigmatullina.org"]=true
DOMAINS["photobarrat.com"]=true
DOMAINS["res-public.net"]=true
DOMAINS["shevastream.com"]=true
DOMAINS["travelus.com.ua"]=true
DOMAINS["veles-russia.com"]=true
DOMAINS["visajapan.com.ua"]=true
DOMAINS["vleskniga.com"]=true
DOMAINS["votings.net"]=true

get-domains () {

	OUTPUT=""

	for domain in "${!DOMAINS[@]}" 
	do
		OUTPUT+="$domain,*.$domain,"
	done

	echo ${OUTPUT%?}
}

get-domains
