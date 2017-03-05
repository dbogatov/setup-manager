source functions.sh

function setup_postgres {

	echo_info "Setting up PostgreSQL"

	[ ! "$(docker ps | grep postgres-db)" ] &&
	docker run \
		--name postgres-db \
		--restart always \
		-p 5432:5432 \
		-e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
		-e POSTGRES_USER=$POSTGRES_USER \
		-e POSTGRES_DB=$POSTGRES_DB \
		-d \
		postgres:alpine

	echo_success "Set up PostgreSQL"
}


