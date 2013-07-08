# always prefer the process man page directory
export MANPATH="${process_dirs[man]:-./doc/man}:${MANPATH:-}";
declare -Ag help_aliases;
declare -g help_stderr="$( mktemp "/tmp/${process_name}.XXXXXX" )";

# add a help man page mapping
help.man.page() {
  local name="${1:-}";
  local filename="${2:-}";
  help_aliases[$name]=$filename;
}

help.man.find() {
  local IFS=':';
  local directories=( ${MANPATH:-} );
  local IFS=$'\n';
  # NOTE: currently this only searches the first path in MANPATH
  local files=( $( find "${directories[0]}" -name "${page:-}" ) );
  unset IFS;
  # TODO: handle multiple files matched?
  if [ "${#files[@]}" -gt 0 ]; then
    manpage="${files[0]}";
  fi
}

# show a man page
help.man.show() {
  executable.validate man;
  local man="${executables[man]}";  
  local page="${1:-}";
  local default="${2:-false}";
  local name=${page%%.*};
  # always prefer mapped help pages
  if ! $default && [ -n "${help_aliases[$name]:-}" ]; then
    page="${help_aliases[$name]}";
  fi
  local manpage="";
  help.man.find;
  if [ -z "${manpage}" ]; then
    console error -- "no manual entry for %s" "${page}";
  elif [ -f "${manpage}" ]; then
    $man "${manpage}" 2>| "$help_stderr";
    return $?;
  fi
}

# attempt to show the default man page for a program
help.man.show.default() {
  local exiting="${1:-true}";
  local manpage=${help_aliases[default]:-};
  if [ -z "$manpage" ]; then
    console quit 1 -- "no help available for %s" "${process_name}";
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
  elif [ $code -gt 0 ] && [ -f "$help_stderr" ]; then
    local err=`cat "$help_stderr"`;
    help.clean;
    console quit $code "$err";
  elif [ $code -gt 0 ]; then
    console quit $code "no man page available";
  fi
}

# cleans the file used for capturing `man` stderr
help.clean() {
  if [ -f "$help_stderr" ]; then
    rm "$help_stderr";
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
    help )
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
