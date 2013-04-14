declare -g delegate_delimiter=".";
delegate() {
  local module=${1:-}; shift;
  local method=${1:-}; shift;
  #TODO: test whether the delegate method exists
  local delegate_method_name="${method}";
  if [ -n "$method" ]; then
    if [ -n "${module}" ]; then
      delegate_method_name="${module}${delegate_delimiter}${method}";
    fi
    #straight method call
    #if [ -z "$module" ]; then
      #"${method}" "$@";
    #method call in module
    #else
      #"${module}${delimiter}${method}" "$@";
    #fi

    unset -v module method;
    if method.exists? "${delegate_method_name}"; then
      "${delegate_method_name}" "$@";
    else
      console error -- "delegate command %s does not exist" \
        "${delegate_method_name}";
    fi
  fi
}
