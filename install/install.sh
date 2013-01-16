export PATH=".:$PATH";

noop=false;
prefix="/usr/local";
man="/usr/local/share/man";
name="strike";

# yum install -y, --assumeyes

parse() {
	while [ "$1" != "" ]; do
		case $1 in
			--prefix )
				shift;
				if test -z "$1"; then
					printf "no prefix specified\n";
					exit 1;
				fi
				prefix="$1";
				if ! test -d "$prefix"; then
					printf "prefix $1 is not a directory\n";
					exit 1;
				fi
				;;
			--noop )
				noop=true;
				;;							
			* )
				printf "invalid option $1\n";
				exit 1;
				;;
		esac
		if [ $# -ne 0 ]; then
			shift;
		else
			break;
		fi
	done
}

parse "$@";

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

# prefix information
printf "using prefix\t\t\t... %s\n" "$prefix";
printf "using install\t\t\t... %s\n" "${prefix}/${name}";
printf "using man\t\t\t... %s\n" "${man}";
printf "using noop\t\t\t... %s\n" "${noop}";

check_command "env" || fatal "env(1) command not found";
check_command "gpg";
check_command "grep";
check_command "sed";
check_command "tee";
check_command "egrep";
check_command "gcc";
check_command "curl";
check_command "find" || fatal "find(1) command not found";
check_command "wget";
{ check_command "bash" && check_bash_version $?; }

if ! $noop; then
	printf "check if everything is ok ... ";
fi