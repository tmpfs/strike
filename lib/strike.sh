declare -g version="";

installer() {
	local tshell="bash";
	local required=( 4 2 );
	local major="${BASH_VERSINFO[0]}";
	local minor="${BASH_VERSINFO[1]}";
	local patch="${BASH_VERSINFO[2]}";
	if { test "$major" -lt "${required[0]}"; } \
		|| { test "$major" -eq "${required[0]}" \
        && test "$minor" -lt "${required[1]}"; }; then
		local version="${major}.${minor}.${patch}";
		printf "$tshell >= ${required[0]}.${required[1]} is required, got %s\n" \
      "$version";
		exit 1;
	fi
}

initialize() {
	installer;
	local dir=`dirname "${BASH_SOURCE[0]}"`;
	dir=$( cd "$dir" && echo "$PWD" );
	local core="${dir}/modules/core";
	# global variable declarations
	. "${core}/globals";
	# we need these modules before we include require(3)
	. "${core}/variable";
	. "${core}/string";
	. "${core}/method";
	. "${core}/sprintf";
	. "${core}/console";
	. "${core}/array";
	. "${core}/fs";
	. "${core}/prompt";
	# set up program header
	string.repeat "${header_character}" \
		"${header_repeat}" "header";
	#NOTE: directories must be configured prior to including require(3)
	# configure program directories
	local dir_root="$exedir";
	local pdir="$exedir";
	fs.path.expand "$pdir";
	pdir="$_result";
	process_dirs[owd]="$PWD";
	process_dirs[bin]="$pdir";
	# cater for executables located in the project root
	if [[ "$exedir" =~ /bin$ ]]; then
		dir_root=`dirname "$exedir"`;
	else
		process_dirs[bin]="${dir_root}/bin";
  fi
  process_dirs[exe]="${pdir}";
	process_dirs[root]="${dir_root}";
	process_dirs[lib]="${dir_root}/lib";
	process_dirs[man]="${dir_root}/man";
	process_dirs[modules]="${dir_root}/lib/modules";
	process_dirs[test]="${dir_root}/test";
	process_dirs[target]="${dir_root}/target";
	process_dirs[package]="${dir_root}/package.json";
	process_dirs[version]="${dir_root}/version";
	process_dirs[semver]="${dir_root}/semver.json";
	process_dirs[data]=~/.${framework}/"${process_name}";
    if [ -f "${process_dirs[version]}" ]; then
        version=$( cat "${process_dirs[version]}" );
    fi
	# configure library directories
	fs.path.expand "$dir";
	dir="$_result";
	dir_root=`dirname "$dir"`;
	library_dirs[root]="${dir_root}";
	library_dirs[bin]="${dir_root}/bin";
	library_dirs[lib]="$dir";
	library_dirs[man]="${dir_root}/man";
	library_dirs[modules]="${dir}/modules";
	library_dirs[test]="${dir_root}/test";
	library_dirs[target]="${dir_root}/target";
	library_dirs[package]="${dir_root}/package.json";
	library_dirs[version]="${dir_root}/version";
	library_dirs[semver]="${dir_root}/semver.json";

	# main module loader and require(3) definition
	. "${core}/require";

  # TODO: register these modules 
	. "${core}/delegate";
	. "${core}/executable";
	. "${core}/system";
	. "${core}/process";

	# manually register these modules
	__require_register "variable" "${core}/variable";
	__require_register "string" "${core}/string";
	__require_register "method" "${core}/method";
	__require_register "sprintf" "${core}/sprintf";
	__require_register "console" "${core}/console";
	__require_register "array" "${core}/array";
	__require_register "require" "${core}/require";
	__require_register "fs" "${core}/fs";
	__require_register "prompt" "${core}/prompt";

	# set up default interactive prompt
	console prompt --program '';
	# remove commands that have
	# served their purpose
	method.remove initialize \
    installer;
}
initialize "$@";
