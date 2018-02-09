#!/usr/bin/env bash

declare -A SERVICES

SERVICES["dbogatov-org"]="registry.dbogatov.org/dbogatov/cv-website:latest"
SERVICES["blog-dbogatov-org"]="registry.dbogatov.org/dbogatov/my-blog:latest"
SERVICES["legacy-dbogatov-org"]="dbogatov/legacy:latest"
SERVICES["socialimps-dbogatov-org"]="registry.dbogatov.org/dbogatov/cs-3043-group-project:latest"
SERVICES["push-dbogatov-org"]="registry.dbogatov.org/dbogatov/pushexpress:latest"
SERVICES["mail-dbogatov-org"]="registry.dbogatov.org/dbogatov/nginx-proxies/mail-dbogatov-org:latest"
SERVICES["dns-dbogatov-org"]="registry.dbogatov.org/dbogatov/nginx-proxies/dns-dbogatov-org:latest"

SERVICES["nigmatullina-org"]="registry.dbogatov.org/dbogatov/inara-cv:latest"

SERVICES["darinagulley-com"]="registry.dbogatov.org/dgulley/dashawebsite:latest"

SERVICES["shevastream-com"]="registry.dbogatov.org/dbogatov/shevastream:master"

SERVICES["visasupport-com-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/php:latest"

SERVICES["visasupport-kiev-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/static/visasupport-kiev-ua:latest"
SERVICES["eu-visasupport-kiev-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/static/eu-visasupport-kiev-ua:latest"
SERVICES["lp-visasupport-kiev-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/static/lp-visasupport-kiev-ua:latest"
SERVICES["zima-visasupport-com-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/static/zima-visasupport-com-ua:latest"
SERVICES["travelus-com-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/static/travelus-com-ua:latest"
SERVICES["visajapan-com-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/static/visajapan-com-ua:latest"

SERVICES["moon-travel-com-ua"]="registry.dbogatov.org/dbogatov/nginx-proxies/moon-travel-com-ua:latest"

SERVICES["vleskniga-com"]="registry.dbogatov.org/slokot/vleskniga:latest"
SERVICES["veles-russia-com"]="registry.dbogatov.org/slokot/veles-russia:latest"

SERVICES["photobarrat-com"]="registry.dbogatov.org/dbogatov/nginx-proxies/photobarrat-com:latest"

SERVICES["bogatov-kiev-ua"]="registry.dbogatov.org/daddy/bogatov-kiev-ua:latest"
SERVICES["blog-bogatov-kiev-ua"]="registry.dbogatov.org/daddy/blog-bogatov-kiev-ua:latest"

###

declare -A DOMAINS

AVALUE="dolores-workers.digital-ocean.dbogatov.org"

DOMAINS["dbogatov.org"]=$AVALUE
DOMAINS["bogatov.kiev.ua"]=$AVALUE
DOMAINS["darinagulley.com"]=$AVALUE
DOMAINS["moon-travel.com.ua"]=$AVALUE
DOMAINS["nigmatullina.org"]=$AVALUE
DOMAINS["photobarrat.com"]=$AVALUE
DOMAINS["res-public.net"]=$AVALUE
DOMAINS["shevastream.com"]=$AVALUE
DOMAINS["travelus.com.ua"]=$AVALUE
DOMAINS["veles-russia.com"]=$AVALUE
DOMAINS["visajapan.com.ua"]=$AVALUE
DOMAINS["visasupport.com.ua"]=$AVALUE
DOMAINS["visasupport.kiev.ua"]=$AVALUE
DOMAINS["vleskniga.com"]=$AVALUE
DOMAINS["votings.net"]=$AVALUE