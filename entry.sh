#!/bin/bash

set -e

source functions.sh
source emacs.sh
source users.sh
source byobu.sh
source docker.sh

echo_info "Start setup"

inc_indent

	echo_info "Reading config"
	. config/global.conf
	echo_success "Config read"

	if [[ $EUID -eq 0 ]]; then
		setup_users
		echo_error "This script must be run as non-root" 
	fi

	echo_info "Updating packages"
	apt_get_quiet update
	echo_success "Packages updated"

	install_emacs

	configure_byobu

	install_docker

dec_indent

echo_success "Setup complete!"
