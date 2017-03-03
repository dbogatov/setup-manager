function add_user {

	echo_info "Adding user $1 with group $2"

	useradd $1 -m -g $2

	echo $1:$3 | sudo chpasswd

	echo_success "User $1 added"
}

function setup_users {
	add_user $USERNAME $USERNAME $PASSWORD
}
