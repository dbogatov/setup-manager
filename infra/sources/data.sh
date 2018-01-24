#!/usr/bin/env bash

declare -A SERVICES

SERVICES["dbogatov-org"]="registry.dbogatov.org/dbogatov/cv-website:latest"
SERVICES["blog-dbogatov-org"]="registry.dbogatov.org/dbogatov/my-blog:latest"
SERVICES["legacy-dbogatov-org"]="dbogatov/legacy:latest"
SERVICES["socialimps-dbogatov-org"]="registry.dbogatov.org/dbogatov/cs-3043-group-project:latest"
SERVICES["push-dbogatov-org"]="registry.dbogatov.org/dbogatov/pushexpress:latest"

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

SERVICES["vleskniga-com"]="registry.dbogatov.org/slokot/vleskniga:latest"
SERVICES["veles-russia-com"]="registry.dbogatov.org/slokot/veles-russia:latest"

SERVICES["bogatov-kiev-ua"]="registry.dbogatov.org/daddy/bogatov-kiev-ua:latest"
SERVICES["blog-bogatov-kiev-ua"]="registry.dbogatov.org/daddy/blog-bogatov-kiev-ua:latest"

###

declare -A DOMAINS

MAINADDR="165.227.217.186"
PHOTOBARRATADDR="192.241.158.207"

DOMAINS["dbogatov.org"]=$MAINADDR
DOMAINS["bogatov.kiev.ua"]=$MAINADDR
DOMAINS["darinagulley.com"]=$MAINADDR
DOMAINS["moon-travel.com.ua"]=$MAINADDR
DOMAINS["nigmatullina.org"]=$MAINADDR
DOMAINS["photobarrat.com"]=$PHOTOBARRATADDR
DOMAINS["res-public.net"]=$MAINADDR
DOMAINS["shevastream.com"]=$MAINADDR
DOMAINS["travelus.com.ua"]=$MAINADDR
DOMAINS["veles-russia.com"]=$MAINADDR
DOMAINS["visajapan.com.ua"]=$MAINADDR
DOMAINS["visasupport.com.ua"]=$MAINADDR
DOMAINS["visasupport.kiev.ua"]=$MAINADDR
DOMAINS["vleskniga.com"]=$MAINADDR
DOMAINS["votings.net"]=$MAINADDR
