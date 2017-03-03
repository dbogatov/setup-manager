function echo_color {
	case $1 in
		"RED")
			COLOR="0;31"
			;;
		"GREEN")
			COLOR="0;32"
			;;
		"BROWN")
			COLOR="0;33"
			;;
		"BLUE")
			COLOR="0;34"
			;;
		"PURPLE")
			COLOR="0;35"
			;;
		"CYAN")
			COLOR="0;36"
			;;
		"GRAY")
			COLOR="0;37"
			;;
		"YELLOW")
			COLOR="1;33"
			;;
		*)
			COLOR="0"
			;;
	esac

	COLOR="\033[${COLOR}m"
	NOCOLOR="\033[0m"

	INDENT=""

	for (( c=1; c<=$CURRENT_INDENT; c++ ))
	do
		INDENT="${INDENT}\t"
	done

	printf "${INDENT}${COLOR}${2}${NOCOLOR}\n"
}

CURRENT_INDENT=0

function inc_indent {
	CURRENT_INDENT=$((CURRENT_INDENT+1))
}

function dec_indent {
	CURRENT_INDENT=$((CURRENT_INDENT-1))
}

function echo_warning {
	echo_color "YELLOW" "$1"
}

function echo_error {
	echo_color "RED" "$1"
}

function echo_success {
	echo_color "GREEN" "$1\n"
}

function echo_info {
	echo_color "CYAN" "$1"
}

function hide_output {
	# This function hides the output of a command unless the command fails
	# and returns a non-zero exit code.

	# Get a temporary file.
	OUTPUT=$(tempfile)

	# Execute command, redirecting stderr/stdout to the temporary file.
	$@ &> $OUTPUT

	# If the command failed, show the output that was captured in the temporary file.
	E=$?
	if [ $E != 0 ]; then
		# Something failed.
		echo
		echo FAILED: $@
		echo -----------------------------------------
		cat $OUTPUT
		echo -----------------------------------------
		exit $E
	fi

	# Remove temporary file.
	rm -f $OUTPUT
}

function apt_get_quiet {
	DEBIAN_FRONTEND=noninteractive hide_output apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" "$@"
}

function apt_install {
	PACKAGES=$@
	apt_get_quiet install $PACKAGES
}

