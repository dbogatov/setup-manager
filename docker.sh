source functions.sh

function install_docker {

	echo_info "Installing docker"

	wget -qO- https://get.docker.com/ | sh

	sudo usermod -aG docker $(whoami)

	apt_install python-pip

	sudo pip install docker-compose

	echo_success "Installed docker"
}

