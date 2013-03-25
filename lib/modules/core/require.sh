# custom require paths added using
# require.path!
# declare -ag __require_paths=();

require() {
	force=${force:-false};
	local name="${1:-}";
	if [ ! -z "$name" ]; then
		__require_load "$name";
	fi
}

# only load a module if it has not already
# been loaded, this prevents the warning generated
# when calling require with a previously loaded module
require.once() {
	# prevent warning if module is loaded
	if ! require.exists? "$1"; then
		require "$1";
	fi
}

# forces a require even if the module is already loaded
require.load() {
	local force=true;
	require "$1";
}

# complex modules stored in directories
# can use this method to source a file 
# relative to the directory containing 
# the module, this essentially load the
# file relative to the script invoking 
# this method
require.library() {
	local file="${1:-}";
	local info;
	require.resolve "info" "1";
	local path="${info[1]}/$file";
	__require_load "$path";
}

# add a custom require path
#TODO: get this working correctly!!!
# function require.path! {
# 	local path="${1:-}";
# 	if [ -n "${path}" ]; then
# 		if [ ! -d "${path}" ]; then
# 			console quit 1 "require path %s is not a directory" "${path}";
# 		fi
# 		__require_paths+=( "${path}" );
# 	fi
# }

# reslve the path, directory and file name
# of the source file that invokes this method
# $1 is the name of the variable to assign an array
# result to with the following entries:
# [0]=basename
# [1]=dirname
# [2]=path
# [3]=function name
# [4]=line number
require.resolve() {
	local varname="${1:-}";
	if [ -n "$varname" ]; then
		local offset="${2:-0}"
		local data=( $( caller "$offset" ) );
		local lineno="${data[0]}";
		local method="${data[1]}";
		local path="${data[2]}";
		local name dir;
		fs.basename "$path" "name";
		fs.dirname "$path" "dir";
		eval "$varname=( \"$name\" \"$dir\" \"$path\" \"$method\" \"$lineno\" )";
	fi
}

require.list() {
	local path name;
	for path in "${!module_paths[@]}"
		do
			name="${module_paths[$path]}";
			info "[module] %s < %s" "$name" "$path";
	done
}

require.methods() {
	_result="";
	require "$1";
	local match="${2:-}";
	if [ ! -z "$2" ]; then
		_result=$( method.list | egrep "$match" );
	fi
}

require.dirs() {
	__require_dirs;
	local searchpaths=( $_result ) d;
	for d in "${searchpaths[@]}"
		do
			console print "$d";
	done
}

# declares a delegate method
require.delegate() {
	local name="${1:-}";
	if [ ! -z "$name" ]; then
		if ! method.exists? "$name"; then
			#warn "loaded module %s does not declare a method named %s" "$name" "$name";
			if method.exists? "delegate"; then
				eval "$name(){ 
					delegate "$1" \$*;
				}";
			fi
		fi
	fi
}

# determines whether a module exists by name or path
require.exists?() {
	local module="${1:-}";
	if [ ! -z "$module" ]; then
		if [[ "$module" =~ ^(\.+)?/ ]]; then
			require.path.exists? "$module";
			return $?;
		else
			#echo "testing for module by name : $module ";
			require.name.exists? "$module";
			return $?;
		fi
	fi
	return 1;
}

# determines whether a module exists by name
require.name.exists?() {
	#echo "testing for name: ${module_paths[@]}";
	if string.contains? "${module_paths[*]}" "${1:-}"; then
		#echo "found module by name : ${1:-}";
		return 0;
	fi
	return 1;
}

# determines whether a module exists by absolute path
require.path.exists?() {
	# echo "testing for path $1 : ${!module_paths[*]}";
	if string.contains? "${!module_paths[*]}" "${1:-}"; then
		return 0;
	fi
	return 1;
}

# TODO: remove private method definitions
# TODO: add require.path.unload!
# TODO: add require.unload! to unload by name or path

# removes a module definition by name
require.name.unload!() {
	local module="${1:-}";
	if [ -n "$module" ]; then
		local paths=( "${!module_paths[@]}" );
		local path name;
		for path in ${paths[@]}
			do
				name="${module_paths["$path"]}";
				if [ "$name" == "$module" ]; then
					if [ ${#module_methods[@]} -gt 0 ]; then
						local methods=( ${module_methods["$path"]} );
						method.remove "${methods[@]}";
					fi
					unset module_paths["$path"];
				fi
		done
	fi
}

######################################################################
#
#	PRIVATE METHODS
#
######################################################################

function __require_register {
	local name="${1:-}";
	local path="${2:-}";
	# strip any extension
	# name=${name%%.*};
	local methods;
	local private;
	if [ ! -z "$name" ]; then
		
		# echo "registering module: $name";
		
		# TODO: only use reflection style stuff in debug mode ???
		# as doing this slows things down noticeably
		
		# get method definitions but don't quit if none are defined
		# methods=( $( method.list | egrep "^${name}" ) );
		# private=( $( method.list | egrep "^__${name}" ) );
		# 
		# # echo "got module private methods: ${private[@]:-}";
		# 
		# module_methods["$path"]="${methods[@]:-}";
		# module_private_methods["$path"]="${private[@]:-}";
		
		module_names["$name"]="$path";
	
		if [ ! -z "$path" ]; then
			module_paths["$path"]="$name";
		fi
	fi
}

function __require_source {
	local name;
	fs.basename "$abs" "name";
	
	# reference a directory, look in directory
	# for a file matching the reference name
	# this allows grouping or complex modules
	# into a directory
	if [ -d "$abs" ]; then
		if [ -f "${abs}/${name}" ] || [ -f "${abs}/${name}.sh" ]; then
			abs="${abs}/${name}";
		else
			console quit 1 "module %s is a directory" "$abs";
		fi
	fi

	
	# only require if path does not match an already loaded module
	# or if the module is being loaded forcefully
	if ! require.path.exists? "$abs" || $force; then
    [[ -f "${abs}.sh" ]] && abs="${abs}.sh";
    #echo "load abs: $abs";
		if [ -f "$abs" ] && [ -r "$abs" ]; then
        #echo "loading abs: $abs";
			. "$abs" || return 1;
    else
      console quit 1 -- "module %s is not a file or unreadable" "$abs";
		fi
	else
		console warn -- "skipping require on loaded module %s" "$abs";
	fi
  return 0;
}

# find the caller source directory
function __require_find_caller_source_dir {
	local self=`dirname $BASH_SOURCE`;
	local index=1;
	local stack=( $( caller $index ) );
	local sourcedir=`dirname "${stack[2]}"`;
	unset _result;
	while [ "$sourcedir" == "$self" ]
		do
			stack=( $( caller $index ) );
			sourcedir=`dirname "${stack[2]}"`;
			if [ "$sourcedir" != "$self" ]; then
				_result="$sourcedir";
				break;
			fi
			: $((index++));
	done
}

function __require_load {
	local name="${1:-}";
	
	local abspath=$(cd ${BASH_SOURCE[0]%/*} && echo $PWD);
	
	#echo "got load abs path: $abspath";
	
	local abs;
	local loaded=1;
	local declared;	
	if [ ! -z "$name" ]; then
		
		# TODO: handle ./ and ../../ paths
		
		# got a relative path, load from a relative path
		if [[ "$name" =~ ^\.+ ]]; then
			__require_find_caller_source_dir;
			sourcefile="$_result";
			sourcefile="${sourcefile}/${name}";
			fs.path.expand "$sourcefile";
			abs="$_result";
			name=`basename $abs`;
      [[ -f "${abs}.sh" ]] && abs="${abs}.sh";
			__require_source "$abs";
			loaded=$?;
			#echo "load relative require $name : $abs";
		# got an absolute path try to load from absolute path			
		elif [[ "$name" =~ ^/ ]]; then
			abs="$name";
			name=`basename $abs`;
      [[ -f "${abs}.sh" ]] && abs="${abs}.sh";
			__require_source "$abs";
			loaded=$?;
		# searching by name
		else
			__require_dirs;
			local searchpaths=( $_result );
			for f in "${searchpaths[@]}"
				do
					#fs.path.expand "$f" > /dev/null;
					#f="$_result";
					abs="${f}/${name}";
          [[ -f "${f}/${name}.sh" ]] && abs="${f}/${name}.sh";
					if [ -r "$abs" ]; then
						__require_source "$abs";
						loaded=$?;
						break;
					fi
			done
		fi
		
		if [ $loaded -eq 1 ]; then
			console quit 1 "failed to load module %s" "$name";
		fi
		
		# echo "testing for delegate method : $name";
		
		# TODO: change name handling for tasks loaded by name
		# eg, tasks/test to correspond to tasks_test
		
		# TODO: check delegate name against the type -f 
		# TODO: to see whether it overrides a builtin
		
		# local internal_type=$( type -t "$name" );
		# 
		# echo "testing internal type for delegate: $name : $internal_type";
		
		# never do delegate functionality for the `test`
		# module otherwise we override the test command		
		
		# TODO: this test is obsolete ???
		# if [ "$name" == test ]; then
		# 	return 0;
		# fi
		
		# only add delegate functionality
		# if the module explicitly marks it using
		# the delegate variable
		local delegate=${delegate:-false};
		if $delegate; then
			require.delegate "$name";
		fi
		# remove the require delegate flag
		unset delegate;
		
		# only delegate and call constructor if the 
		# module was required
		if ! require.path.exists? "$abs" || $force; then
			# register the module
			__require_register "$name" "$abs";
		fi
		
		# NOTE: handle tasks/ext/build/ant style requires
		# NOTE: constructor becomes: tasks.ant.initialize
		local cname="${name}";
    #cname="${cname#*/}"
		if [[ "$cname" =~ / ]]; then
			local cprefix="${cname%%/*}";
			local csuffix="${cname##*/}";
			cname="${cprefix}.${csuffix}";
		fi
		#echo "cname is $cname"
		# always call the constructor if possible
		local constructor="${cname}.initialize";
		# invoke a contructor if present
		if method.exists? "$constructor"; then
			"$constructor";
		fi
	fi
}

function __require_dirs {
	local exemodules="${process_dirs[modules]}";
	local libmodules="${library_dirs[modules]}";
	local searchpaths=(
		"${exemodules}"
		"${libmodules}"
	);

  # cater for bake(1) when it is a symbolic link
  if [ -n "${root:-}" ] && [ -d "${root}/lib/modules" ]; then
    searchpaths+=( "${root}/lib/modules" );
  fi

	# if [ -n "${__require_paths[*]}" ]; then
	# 	if [ ${#__require_paths[@]} -gt 0 ]; then
	# 		searchpaths+=( ${__require_paths[@]} );
	# 	fi
	# fi
	
	# look for node_modules that may contain
	# files to include, must have a `tasks`
	# file present in the root and must have a
	# nested lib/modules folder to be included
	if [ -d "./node_modules" ]; then
		local dir;
		for dir in ./node_modules/*
			do
				# echo "testing for node_modules lib : ${dir}"
				if [ -d "${dir}" ] && [ -f "${dir}/tasks" ]; then
					if [ -d "${dir}/lib/modules" ]; then
						searchpaths+=( "${dir}/lib/modules" );
					fi
				fi
		done
	fi
	_result="${searchpaths[@]}";
}
