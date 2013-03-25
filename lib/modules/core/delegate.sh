declare -grx delegate_delimiter=".";
delegate() {
  # method pseudo-namespace delimiter
  local delimiter="${delegate_delimiter}";
  local module=${1:-};
  shift;
  # TODO: only shift if we have more options to process
  local method=${1:-};
  shift;
  #TODO: test whether the delegate method exists
  if [ ! -z "$method" ]; then
    #straight method call
    if [ -z "$module" ]; then
      "${method}" "$@";
    #method call in module
    else
      "${module}${delimiter}${method}" "$@";
    fi
  fi
}