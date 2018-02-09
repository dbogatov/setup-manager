#!/usr/bin/env bash 

set -e

shopt -s globstar

declare -A DOMAINS

# Have not decided what the value should mean...

DOMAINS["dbogatov.org"]=true
DOMAINS["status.dbogatov.org"]=false
DOMAINS["blog.dbogatov.org"]=false
DOMAINS["legacy.dbogatov.org"]=false
DOMAINS["push.dbogatov.org"]=false
DOMAINS["socialimps.dbogatov.org"]=false
DOMAINS["mail.dbogatov.org"]=false
DOMAINS["dns.dbogatov.org"]=false
DOMAINS["dashboard.dbogatov.org"]=false

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

DOMAINS["shevastream.com/home"]=true

DOMAINS["travelus.com.ua"]=true

DOMAINS["veles-russia.com"]=true

DOMAINS["visajapan.com.ua"]=true

DOMAINS["vleskniga.com"]=true

for domain in "${!DOMAINS[@]}" 
do
	code=$(curl -s -o /dev/null -I -w "%{http_code}" https://$domain)

	echo "$code : $domain"
done

echo "Done!"
