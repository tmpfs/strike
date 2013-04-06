declare -Agx url_params;

url.encode() {
  local param="${1:-}";
  local name="${2:-}";
  local opts="-s -o /dev/null -w %{url_effective} --get --data-urlencode";
  local data=$(curl $opts "${param}" "")
  data="${data##/?}";
  variable.set "${name}" "${data}";
}

url.params.clear() {
  url_params=();
}

url.params.add() {
  local name="${1:-}";
  local value="${2:-}";
  if [ ! -z "$name" ]; then
    url_params[$name]="$value";
  fi
}

url.params.stringify() {
  local opts=();
  local p;
  for p in ${!url_params[@]}
    do
      # echo "got url param : $p";
      opts+=( "${p}=${url_params[$p]}" );
  done
  url.query.string "${opts[@]:-}";
}

url.query.string() {
  local output="";
  local oifs;
  for opt in "${@}"
    do
      local IFS="=";
      while read -r name value
        do
          if [ -z "$name" ] || [ -z "$value" ]; then
            continue;
          fi
          url.encode "$value" "value";
          # echo "encoding name: ${name}";
          # echo "encoding value: ${_result}";
          output="${output}${name}=${value}&";
      done <<< "$opt";
  done
  if [ ! -z "$output" ]; then
    #strip trailing ampersand
    output="${output%&}";   
    _result="?${output}";
  else
    _result="";
  fi
}
