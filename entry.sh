#!/bin/bash

set -e

source functions.sh
source emacs.sh
source users.sh
source byobu.sh

echo_info "Start setup"

inc_indent

	if [[ $EUID -eq 0 ]]; then
		echo_error "This script must be run as non-root" 
	fi

	echo_info "Reading config"
	. config/global.conf
	echo_success "Config read"

	echo_info "Updating packages"
	sudo apt_get_quiet update
	echo_success "Packages updated"

	install_emacs

	setup_users

	configure_byobu

dec_indent

echo_success "Setup complete!"
