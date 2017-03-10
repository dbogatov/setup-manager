source functions.sh

function install_docker {

	echo_info "Installing docker"
	inc_indent

		echo_info "Installing Docker from get.docker.com script"
		
		wget -qO- https://get.docker.com/ | sh

		echo_info "Adding user to docker group"
		sudo usermod -aG docker $(whoami)

		echo_info "Installing PIP"
		apt_install python-pip

		echo_info "Installing Docker Compose"
		sudo pip install docker-compose

	dec_indent
	echo_success "Installed docker"
}

