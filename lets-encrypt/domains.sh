#!/usr/bin/env bash

declare -A DOMAINS

DOMAINS["dbogatov.org"]=true
DOMAINS["status.dbogatov.org"]=false
DOMAINS["blog.dbogatov.org"]=false
DOMAINS["legacy.dbogatov.org"]=false
DOMAINS["push.dbogatov.org"]=false
DOMAINS["socialimps.dbogatov.org"]=false
DOMAINS["mail.dbogatov.org"]=false
DOMAINS["dns.dbogatov.org"]=false
DOMAINS["vpn.dbogatov.org"]=false
DOMAINS["apt.dbogatov.org"]=false
DOMAINS["dashboard.dbogatov.org"]=false
DOMAINS["cluster.dbogatov.org"]=false
DOMAINS["grafana.dbogatov.org"]=false
DOMAINS["git.dbogatov.org"]=false
DOMAINS["pages.dbogatov.org"]=false
DOMAINS["mattermost.dbogatov.org"]=false
DOMAINS["minecraft.dbogatov.org"]=false
DOMAINS["ci.dbogatov.org"]=false
DOMAINS["registry.dbogatov.org"]=false
DOMAINS["dns.dbogatov.org"]=false


DOMAINS["bogatov.kiev.ua"]=true
DOMAINS["blog.bogatov.kiev.ua"]=false

DOMAINS["visasupport.com.ua"]=true
DOMAINS["zima.visasupport.com.ua"]=false

DOMAINS["visasupport.kiev.ua"]=true
DOMAINS["eu.visasupport.kiev.ua"]=false
DOMAINS["lp.visasupport.kiev.ua"]=false

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
		OUTPUT+="$domain,"
		
		if [ "${DOMAINS[${domain}]}" = true ] ; then
			OUTPUT+="www.$domain,"
		fi

		OUTPUT+="${domain//./-}.cluster.dbogatov.org,"

	done

	echo ${OUTPUT%?}
}

get-domains
