export PATH=".:$PATH";

fatal() {
	printf "$1\n";
	exit 1;
}

check_bash_version() {
	if test $? -eq 0; then
		ske_version_str=$( bash -c 'printf "${BASH_VERSINFO[0]} ${BASH_VERSINFO[1]} ${BASH_VERSINFO[2]}"' );
		printf "checking bash version\t\t... $ske_version_str";
	else
		# TODO: install bash in this instance
		printf "bash is not installed";
		exit 1;
	fi
	print_newline;	
}

print_newline() {
	printf "\n";
}

check_command() {
	printf "%s %s\t\t%s" "checking for" "$1" "... ";
	ske_result=$( command -v "$1" );
	ske_result_code=$?;
	if test -n "$ske_result"; then
		printf "%s" "yes ($ske_result)";
		# no arrays in posix so use 
		eval "$1=\"$ske_result\"";
	else
		printf %s "no";
	fi
	print_newline;
	return $ske_result_code;
}

check_command "env";
if test $? -gt 1; then
	fatal "env command not found";
fi
check_command "gpg";
check_command "grep";
check_command "sed";
check_command "awk";
check_command "tee";
check_command "egrep";
check_command "gcc";
check_command "bash";
#check_bash_version $?;
check_command "curl";
check_command "find";
check_command "wget";