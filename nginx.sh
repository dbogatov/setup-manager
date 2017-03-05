source functions.sh

function setup_nginx {

	echo_info "Setting up NGINX"

	apt_install nginx

	mkdir -p tmp
	cd tmp
	curl --header "PRIVATE-TOKEN: $TOKEN" https://git.dbogatov.org/api/v4/projects/15/builds/artifacts/master/download?job=artifacts > nginx.zip
	unzip nginx.zip
	sudo cp -r dist/* /etc/nginx/
	cd ..
	rm -rf tmp

	echo_success "Set up NGINX"
}
