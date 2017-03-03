source functions.sh

function install_emacs {

	echo_info "Installing emacs"

	apt_install emacs

	mkdir -p /root/.emacs.d/
	cp config/emacs/init.el /root/.emacs.d/init.el
	cp config/emacs/init.el /home/$USERNAME/.emacs.d/init.el

	echo_success "Installed emacs"
}
