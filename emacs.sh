source functions.sh

function install_emacs {

	echo_info "Installing emacs"

	apt_install emacs

	mkdir -p /home/$USERNAME/.emacs.d/
	cp config/emacs/init.el ~/.emacs.d/init.el

	echo_success "Installed emacs"
}
