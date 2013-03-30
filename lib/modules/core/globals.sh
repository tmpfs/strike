declare -rg framework="strike";
declare -agx program_options=( "$@" );
declare -gx process_name="`basename $0`";

declare -agx global_options;
global_options=( "--version" );

declare -Agx library_dirs;
declare -Agx process_dirs;

declare -Agx executables;

declare -gx username=$( id -nu );
declare -lgx platform=$( uname -s );

declare -gx linux_platform="linux";
declare -gx darwin_platform="darwin";

declare -Agx platforms;
platforms[linux]=false;
platforms[darwin]=false;

[[ "$platform" == "$linux_platform" ]] \
  && platforms[linux]=true;

[[ "$platform" == "$darwin_platform" ]] \
  && platforms[darwin]=true;

declare -Agx console_prefixes;
console_prefixes['info']="info";
console_prefixes['error']="error";
console_prefixes['warn']="warn";
console_prefixes['ok']="ok";
console_prefixes['notok']="not ok";
console_prefixes['prompt']="prompt";
console_prefixes['trace']="trace";
console_prefixes['debug']="debug";
console_prefixes['log']="log";

console_prefixes['header']="";
console_prefixes['print']="";

declare -Agx module_paths;
declare -Agx module_names;

# TODO: deprecate these
declare -Agx module_methods;
declare -Agx module_private_methods;

# utility characters
declare -Ag characters;
characters[tick]="✓";
characters[cross]="✘";
characters[lightning]="⚡";

# character header used as a delimiter for program output
declare -g header="";
declare -g header_character="${strike_header_character:-+}";
declare -g header_repeat="${strike_header_repeat:-auto}";

if [ -n "${header_repeat:-}" ] \
	|| [ "${header_repeat}" == "auto" ]; then
	COLUMNS=$( tput cols || printf 80 );
	LINES=$( tput lines || printf 24 );
	header_repeat="${COLUMNS:-80}";
fi

# generic suffic for prompts
export PS9_SUFFIX="${characters[lightning]} ";

# custom ps prompt
export PS9=" ${PS9_SUFFIX}";
