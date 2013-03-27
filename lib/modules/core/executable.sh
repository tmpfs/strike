executable.validate() {
  local opt cmd="";
  local strict=true;
  if [ "$1" == "--test" ]; then
    strict=false;
    shift;
  fi
  for opt in ${@}
    do  
      # skip executables we've already found
      if [ -n "${executables[$opt]:-}" ]; then
        continue;
      fi
      cmd=$( command -v "$opt" );
      if [ -z "$cmd" ] && $strict; then
        console quit 1 "%s is not available" "$opt";
      fi
      #if [ ! -x "$cmd" ]; then
        ## under some circumstances command -v returns
        ## just the executable name so we look in $PATH
        ## for the executable path
        #executable.find "$opt";
        #if [ -n "$_result" ]; then
          #cmd="$_result";
        #elif $strict; then
          #console quit 1 "%s at %s is not executable" "$opt" "$cmd";
        #fi
      #fi
      [[ -n "${cmd}" ]] && executables["$opt"]="$cmd";
  done
}

# converts $PATH to an array
#executable.path() {
  #_result="";
  ## TODO: move to string.split
  #local IFS=":";
  #set $PATH;
  #_result="$@";
  #unset IFS;
#}

# finds the first executable in $PATH
#executable.find() {
  #local opt paths path;
  #for opt in ${@}
    #do
      #executable.path;
      #paths=( $_result );
      #_result="";
      #for path in ${paths[@]}
        #do
          #if [ -x "${path}/${opt}" ]; then
            ##_result="${path}/${opt}";
            #executables["$opt"]="${path}/${opt}";
            #return 0;
          #fi
      #done
  #done
#}
