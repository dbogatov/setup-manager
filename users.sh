function add_user {

	id -u $USERNAME &>/dev/null \
	&& echo_success "User $USERNAME exists" || {

		echo_info "Adding user $1 with group $1"
		inc_indent

		useradd $1 -m -U

		echo $1:$2 | sudo chpasswd

		if $3 ; then
			echo_info "Here" ;
			gpasswd -a dbogatov sudo ;
		fi

		dec_indent
		echo_success "User $1 added"
	}
}

function setup_users {
	add_user $USERNAME $PASSWORD true
}
