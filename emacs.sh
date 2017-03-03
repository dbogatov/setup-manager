source functions.sh

function install_emacs {

	echo_info "Installing emacs"

	apt_install emacs

	sudo mkdir -p /root/.emacs.d/
	sudo cp config/emacs/init.el /root/.emacs.d/init.el

	mkdir -p /home/$USERNAME/.emacs.d/
	cp config/emacs/init.el /home/$USERNAME/.emacs.d/init.el

	echo_success "Installed emacs"
}
