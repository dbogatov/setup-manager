#!/bin/bash

source functions.sh

source emacs.sh


echo_info "Start setup"

apt_get_quiet update

install_emacs

echo_success "Setup complete!"
