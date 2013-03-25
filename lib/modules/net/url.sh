declare -Agx url_params;

function url.encode {
    local data=$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "$1" "")
    _result="${data##/?}";
}

function url.params.clear {
  url_params=();
}

function url.params.add {
  local name="${1:-}";
  local value="${2:-}";
  if [ ! -z "$name" ]; then
    url_params[$name]="$value";
  fi
}

function url.params.stringify {
  local opts=();
  local p;
  for p in ${!url_params[@]}
    do
      # echo "got url param : $p";
      opts+=( "${p}=${url_params[$p]}" );
  done
  url.query.string "${opts[@]:-}";
}

function url.query.string {
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
          url.encode "$value";
          # echo "encoding name: ${name}";
          # echo "encoding value: ${_result}";
          output="${output}${name}=${_result}&";
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