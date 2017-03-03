source functions.sh

function configure_byobu {

	echo_info "Configuring byobu"

	byobu-enable

	cp config/byobu/status /home/$USERNAME/.byobu/status

	echo_success "Configured byobu"

}