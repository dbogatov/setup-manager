#!/usr/bin/env bash

NETWORK="internal"

declare -A SERVICES

SERVICES["dbogatov-org"]="registry.dbogatov.org/dbogatov/cv-website"
SERVICES["blog-dbogatov-org"]="registry.dbogatov.org/dbogatov/my-blog"
SERVICES["nigmatullina-org"]="registry.dbogatov.org/dbogatov/inara-cv"
SERVICES["darinagulley-com"]="registry.dbogatov.org/dgulley/dashawebsite"
SERVICES["legacy-dbogatov-org"]="dbogatov/legacy"
SERVICES["socialimps-dbogatov-org"]="registry.dbogatov.org/dbogatov/cs-3043-group-project"
SERVICES["shevastream-com"]="registry.dbogatov.org/dbogatov/shevastream:master"
SERVICES["visasupport-com-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/php"
SERVICES["visasupport-kiev-ua"]="registry.dbogatov.org/dbogatov/visasupport-websites/static"
SERVICES["vleskniga-com"]="registry.dbogatov.org/slokot/vleskniga"
SERVICES["veles-russia-com"]="registry.dbogatov.org/slokot/veles-russia"
SERVICES["bogatov-kiev-ua"]="registry.dbogatov.org/daddy/bogatov-kiev-ua"
SERVICES["blog-bogatov-kiev-ua"]="registry.dbogatov.org/daddy/blog-bogatov-kiev-ua"
SERVICES["push-dbogatov-org"]="registry.dbogatov.org/dbogatov/pushexpress"
