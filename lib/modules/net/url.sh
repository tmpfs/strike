declare -Ag mime_types;
mime_types[json]="application/json";
mime_types[octet]="application/octet-stream";

url() {
  local varname="";
  declare -A parameters;
  if [ $# -eq 0 ]; then
    console error -- "no url command specified";
  else
    local url_namespace="url.commands";
    local cmd="${1:-}"; shift;
    if ! method.exists? "${url_namespace}.${cmd}"; then
      console error -- "unknown url command %s" "${cmd}";
    else
      delegate "${url_namespace}" "${cmd}" "$@";
    fi
  fi
}

url.commands.query() {
  varname="${1:-}"; shift;
  if [ -z "${varname}" ]; then
    console warn -- "no query string variable name specified for url encode";
  else
    url.options.parse "$@";
    local name value encoded;
    local encoded_params=();
    for name in ${!parameters[@]}
      do
        value="${parameters[$name]:-}";
        url.encode "${value}";
        encoded_params+=( "${name}=${encoded}" );
    done
    #echo "encoded == ${encoded_params[@]:-}";
  fi
  if [ ${#encoded_params[@]} -gt 0 ]; then
    local IFS="&";
    local query="${encoded_params[@]}";
    unset IFS;
    #echo "got query: $query"
    variable.set "${varname}" "${query}";
  fi
}

url.commands.encode() {
  local value="${1:-}"; shift;
  local varname="${2:-encoded}"; shift;
  local encoded;
  url.encode "${value}";
  variable.set "${varname}" "${encoded}";
}

url.options.parse() {
  local opt name value;
  while [ -n "${1:-}" ]
    do
      #echo "got param $1";
      case $1 in
        --*)
          opt="$1";
          if [[ "${opt}" =~ = ]]; then
            opt="${opt#--}";
            name="${opt%=*}";
            value="${opt#*=}";
            #echo "name=$name";
            #echo "value=$value";
            if [ -n "${value}" ]; then
              parameters[$name]="${value}";
            fi
          fi
          ;;
      esac
      shift;
  done
}

## PRIVATE

url.encode() {
  local param="$*";
  local opts="-s -o /dev/null -w %{url_effective} --get --data-urlencode";
  encoded=$(curl $opts "${param}" "")
  encoded="${encoded##/?}";
}
