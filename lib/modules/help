# TODO: include program name in this .tmp file, to prevent conflicts
# TODO: or just redirect to /dev/null?
declare -gx __help_stderr_file="$HOME/.help.stderr";
declare -Agx __help_manpages;
declare -agx __help_manpath;
__help_manpath=();

# validates required executables and
# sets up the default man search paths
help.initialize() {
  executable.validate man;
  # set up default man paths
  help.man.path "${process_dirs[man]}";
}

# add a help man path search directory
help.man.path() {
  __help_manpath+=( "$1" );
}

# add a help man page mapping
help.man.page() {
  local name="${1:-}";
  local filename="${2:-}";
  __help_manpages[$name]=$filename;
}

# show a man page
help.man.show() {
  local man="${executables[man]}";  
  local page="${1:-}";
  local default="${2:-false}";
  local name=${page%%.*};
  # always prefer mapped help pages
  if ! $default && [ -n "${__help_manpages[$name]:-}" ]; then
    page="${__help_manpages[$name]}";
  fi
  local path file displayed=0;
  if [ ! -z "$page" ]; then
    for path in ${__help_manpath[@]}
      do
        file="${path}/${page}";
        if [ -f "$file" ]; then
          displayed=1;    
          $man "$file" 2>| "$__help_stderr_file";
          return $?;
        fi
    done
    if [ $displayed -eq 0 ]; then
      array.join ":" "${__help_manpath[@]}";
      local manpath="$_result";
      $man -M "$manpath" "$name" 2>| "$__help_stderr_file";
      return $?;
    fi
  fi
}

# attempt to show the default man page for a program
help.man.show.default() {
  local exiting="${1:-true}";
  local manpage=${__help_manpages[default]:-};
  if [ -z "$manpage" ]; then
    console quit 1 "no help available for %s" "`basename $0`";
  fi
  help.man.show "$manpage" true;
  if $exiting; then
    help.exit "$?";
  fi
}

# handles exiting once a help option has been processed
help.exit() {
  local code="$1";
  # everything went ok so just quit
  if [ $code -eq 0 ]; then
    exit 0;
  # got an error status and custom error output
  elif [ $code -gt 0 ] && [ -f "$__help_stderr_file" ]; then
    local err=`cat "$__help_stderr_file"`;
    help.clean;
    console quit $code "$err";
  elif [ $code -gt 0 ]; then
    console quit $code "no man page available";
  fi
}

# cleans the file used for capturing `man` stderr
help.clean() {
  if [ -f "$__help_stderr_file" ]; then
    rm "$__help_stderr_file";
  fi
}

# inspect the program options looking for a help option
# and display the appropriate man page if possible
help.parse() {
  help.clean;
  local section;
  local manpage;
  # we only check the first parameter
  # so that task proxy commands can show
  # help for proxies
  case "${1:-}" in
  -h | --help | help )
    shift;
    section="${1:-}";
    # nothing specified after the help option
    # try to show the default help man page
    if [ $# -eq 0 ]; then
      help.man.show.default;
    # try to show a specific man page
    else
      help.man.show "$section";
      help.exit "$?";
    fi
    ;;
  esac
}
