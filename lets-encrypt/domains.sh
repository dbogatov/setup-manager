#!/usr/bin/env bash

declare -A DOMAINS

MAIN=("dbogatov.org" "dmytro.app" "bogatov.app")

# boolean value indicates if non-wildcard cert should be requested

DOMAINS["__MAIN__"]=true
DOMAINS["cluster.__MAIN__"]=false
DOMAINS["pages.__MAIN__"]=false

DOMAINS["netwatch.app"]=true
DOMAINS["orlova.app"]=true
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
		if [[ $domain = *"__MAIN__"* ]]
		then
			for main in ${MAIN[@]}
			do
				newdomain=${domain/__MAIN__/$main}
				if [ ${DOMAINS[${domain}]} == true ]
				then
					OUTPUT+="$newdomain,*.$newdomain,"
				else
					OUTPUT+="*.$newdomain,"
				fi
			done
		else
			if [ ${DOMAINS[${domain}]} == true ]
			then
				OUTPUT+="$domain,*.$domain,"
			else
				OUTPUT+="*.$domain,"
			fi
		fi
	done

	echo ${OUTPUT%?}
}

get-domains
