#!/bin/bash

source functions.sh

source emacs.sh

echo_info "Start setup"

inc_indent

	echo_info "Reading config"
	. config/global.conf
	echo_success "Config read"


	echo_info "Updating packages"
	apt_get_quiet update
	echo_success "Packages updated"

	install_emacs

dec_indent

echo_success "Setup complete!"
