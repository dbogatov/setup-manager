source functions.sh

function install_emacs {

	echo_info "Installing emacs"

	apt_install emacs

	mkdir -p /root/.emacs.d/
	mv config/emacs/init.el /root/.emacs.d/init.el

	echo_success "Installed emacs"
}
