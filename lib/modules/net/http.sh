require net/url;

process.directory http;

declare -Ag http_res_headers;
declare -Ag http_req_headers;

declare -Ag http;
http[writeout]="%{http_code}\n%{url_effective}\n%{time_total}\n%{num_redirects}\n%{filename_effective}\n";
http[redirects]=true;
http[strict]=false;
# determines whether curl(1) stderr output is also
# printed to the screen
http[printstderr]=false;
http[response.redirects]=0;
http[status]="000";
http[exit.code]=1;
http[auth.user]="";
http[auth.pass]="";
http[request.method]="";

http() {
  executable.validate curl tee;
  local namespace="http.commands";
  local cmd="${1:-}";
  shift;

  if [ "${cmd}" != init ] && [ -z "${http[home]:-}" ]; then
      console error -- "no http directory initialized";
  else
    if ! method.exists? "${namespace}.$cmd"; then
      console error -- "unknown http command %s" "$cmd";
    else
      delegate "${namespace}" "$cmd" "$@";
    fi
  fi
}

# initialize where the module stores files
http.commands.init() {
  local folder="${1:-}";
  if [ -d "${folder}" ] && [ -w "${folder}" ]; then
    http[home]="${folder}";
  fi
  if [ ! -d "${http[home]}" ]; then
    mkdir -p "${http[home]}";
  fi
  http[head.file]="${http[home]}/http.head";
  http[body.file]="${http[home]}/http.body";
  http[exit.file]="${http[home]}/http.exit";
  http[trace.ascii.file]="${http[home]}/http.trace.ascii";
  http[head.dump.file]="${http[home]}/http.head.dump";
  http[stderr.file]="${http[home]}/http.stderr";
  http[stdout.file]="${http[home]}/http.stdout";
}

http.commands.get() {
  local url="${1:-}";
  http.curl "GET" "$url";
}

http.commands.head() {
  local url="${1:-}";
  http.curl "GET" "$url" "--head";
}

http.commands.post() {
  local url="${1:-}";
  http.curl "POST" "$url";
}

http.commands.put() {
  local url="${1:-}";
  http.curl "PUT" "$url";
}

http.commands.delete() {
  local url="${1:-}";
  http.curl "DELETE" "$url";
}

http.commands.options() {
  local url="${1:-}";
  http.curl "OPTIONS" "$url";
}

## PRIVATE

http.clean() {
  local keys=(
    head.file
    exit.file
    trace.ascii.file
    head.dump.file
    stderr.file
    stdout.file
  );
  local k f;
  for k in ${keys[@]}
    do
      f="${http[$k]}";
      if [ -f "$f" ]; then
        rm -v "$f";
      fi
  done
}

http.curl.execute() {
  local cmd="${executables[curl]}"; 
  local tee="${executables[tee]}";
  local results=();
  local runopts=( "$@" );
  
  if [ ! -x "$cmd" ]; then
    console quit 1 -- "could not locate curl executable %s" "$cmd";
  fi  
  
  #ensure all files are removed before we start
  #so we don't leave any previous request data
  #around when a request fails
  http.clean > /dev/null; 

  #ensure we unset all variables before the next request
  #TODO: move to a method for unsetting by group
  for opt in ${!http_response_*}
    do
      unset "$opt";
  done
  
  #echo "$FUNCNAME: ${#runopts[@]} : ${runopts[@]}";
    
  # redirect stderr with tee, useful for also
  # displaying file download progress
  if ${http[printstderr]}; then
    echo "${http[config]}" | $cmd --config - 2>| \
      >($tee "${http[stderr.file]}" >&2) 1>| "${http[stdout.file]}" \
      || echo -n "$?" >> "${http[exit.file]}";  
  # not redirecting stderr to screen as well
  # so just send to the file
  else
    echo "${http[config]}" | $cmd --config - 2>| \
      "${http[stderr.file]}" 1>| "${http[stdout.file]}" \
      || echo -n "$?" >> "${http[exit.file]}";
  fi
  
  # get the write out results
  results=( $( < "${http[stdout.file]}" ) );
  
  # echo "got results: ${results[@]}";
  
  http_exit_code=0;
  if [ -f "${http[exit.file]}" ]; then
    http_exit_code=$( cat "${http[exit.file]}" );
    http_exit_code=${http_exit_code:-0};
  fi
  
  # echo "got curl exit code: $http_exit_code";
  
  if [ ${#results[@]} -gt 2 ]; then
    http[status]="${results[0]}";
    http[effective.url]="${results[1]}";
    http[response.time.total]="${results[2]}";
    http[response.redirects]="${results[3]:-0}";
  fi

  if [ "$http_exit_code" != "0" ]; then
    if [ "${http[strict]}" == true ]; then
      if [ -f "${http[stderr.file]}" ]; then
        console error -- "$( cat ${http[stderr.file]} )";
      fi
      console quit $http_exit_code -- \
        "curl exited with non-zero status code (%s)" "$http_exit_code";
    else
      if [ -f "${http[stderr.file]}" ]; then
        console error -- "$( cat ${http[stderr.file]} )";
      else
        console error -- \
          "curl exited with non-zero status code (%s)" "$http_exit_code";
      fi
    fi
  fi
  
  if [ -f "${http[body.file]}" ] && [ "$http_exit_code" == "0" ]; then
    # parse response headers into variable data
    http.response.parse "${http[head.dump.file]}";
  fi
}

http.curl() {
  local method="${1:-GET}"; shift;
  local url="${1:-}"; shift;
  
  #remaining custom options
  local opts=( "$@" );

  if [[ "$url" =~ ^[a-zA-Z]+: ]]; then
    if [[ ! "$url" =~ ^https?: ]]; then
      console warn -- "invalid url protocol must be %s or %s" "http" "https";
      return 1;
    fi
  fi
  
  local runopts=(
    "--request"
    "${method}"
    "--show-error"
  );

  if [ "${http[redirects]}" == true ]; then
    runopts+=(--location);
  fi
  
  if [ -n "${http[auth.user]:-}" ] && [ -n "${http[auth.pass]:-}" ]; then
    runopts+=( "--user" "${http[auth.user]}:${http[auth.pass]}" );
  fi
  
  runopts+=(
    "--dump-header"
    "${http[head.dump.file]}"
    "--trace-ascii"
    "${http[trace.ascii.file]}"
    "--write-out"
    "${http[writeout]:-}"
  );
  
  #pass in custom opts
  if [ ${#opts[@]} -gt 0 ]; then
    #echo "adding custom options... ${opts[@]}";
    runopts+=( "${opts[@]}" );
  fi
  
  if ! array.contains? "-#" "${runopts[@]}" \
    || ! ${http[printstderr]}; then
    runopts+=(--silent);
  fi

  local body="${http[body.file]}";
  if ! array.contains? "--output" "${runopts[@]}"; then
    if array.contains? "--head" "${runopts[@]}"; then
      http[body.file]="${http[head.file]}";
    fi
    runopts+=( --output "${http[body.file]}" );
  fi

  runopts=( "${runopts[@]}" --url "$url" );

  http[request.method]="${method}";
  http[request.url]="${url}";
  # build options to pass to curl(1) via stdin
  http[config]=$( http.config "${runopts[@]}" );

  # execute the request
  http.curl.execute "${runopts[@]}";

  http[body.file]="${body}";
}

http.config() {
  local opts=( "$@" );
  local i val next;
  for((i = 0;i < $#;i++))
    do
      val=${opts[$i]};
      next=${opts[i+1]:-};
      if [ ! -z "$next" ]; then
        if [[ ! "$next" =~ ^--[a-z] ]]; then
          echo "$val=\"$next\"";
          i=$[i + 1];
          continue;
        else
          echo "$val";
        fi
      fi
  done
}

http.response.status.parse() {
  local raw="${@:2}";
  local index="$1";
  shift;
  if [ "$index" -eq "${http[response.redirects]:-0}" ]; then
    http_res_status="${raw}";
  fi
  # echo "got response raw : $raw";
  # echo "got response index : $index";
  #local opts=();
  #for opt in ${@}
    #do
      ## echo "got opt : $opt";
      ##TODO : change this to += 
      #opts=( "${opts[@]:-}" "$opt" );
  #done
  #eval "export http_header_${index}_raw='${raw}'";
  ##skip the first empty element in the array
  #export "http_header_${index}_http="${opts[1]:-}"";
  #export "http_header_${index}_status="${opts[2]:-}"";
  #export "http_header_${index}_message="${opts[3]:-}"";
}

http.header.parse() {
  local index="$1";
  local name="${2%: ?*}";
  local value="${2#*:}";
  # raw header information for final
  # set of headers
  if [ "$index" -eq "${http[response.redirects]}" ]; then
    http_res_headers["${name}"]="${value}";
  fi
  
  #convert hyphens to underscores
  #name="${name//-/_}";
  
  #lowercase name
  #name=${name,,};
  
  #strip leading whitespace
  #string.ltrim "$value";
  #value="$_result";
  
  # echo "got name: $name";
  # echo "got value: $value";
  
  #TODO: only export on the last header set received
  #export "http_header_${index}_${name}=${value}";
}

http.response.parse() {

  # TODO: refactor to use the http array
  declare -g http_res_status="";
  declare -g http_req_status="";

  unset http_res_headers;
  declare -Ag http_res_headers;

  unset http_req_headers;
  declare -Ag http_req_headers;
  http.req.headers;

  # number of redirects corresponds to the number of headers to parse
  local redirects=${http[response.redirects]:-0};
  local index=0;
  local output="$1";
  local head=0;
  while IFS= read -r line
    do
      http.line;
  done < "$output";
  # process last line
  if [ -n "$line" ]; then http.line; fi
}

# parse request header
http.req.headers() {
  local start="^=> Send header";
  local prefix="^([0-9a-f]+:[ ])";
  local end="${prefix}\$";
  local match="${prefix}(.*)";
  local inside=false;
  local name value;
  while IFS= read -r line
    do
      if [[ "${line}" =~ $start ]]; then
        inside=true; continue;
      fi
      if [[ "${line}" =~ $end ]]; then
        #echo "finished in $line"
        return 0;
      fi
      if $inside; then
        #echo "inside $line"
        if [[ "${line}" =~ $match ]]; then
          if [ -z "${http_req_status:-}" ]; then
            http_req_status="${BASH_REMATCH[2]}";
          else
            line="${BASH_REMATCH[2]:-}";
            name="${line%: ?*}";
            value="${line#*:}";
            #echo "var $name || $value"
            http_req_headers[$name]="${value}";
          fi
        fi
      fi
  done < "${http[trace.ascii.file]}";
}

http.line() {
  #parse the HTTP declaration
  if [[ "$line" =~ ^HTTP/1.[01] ]]; then
    http.response.status.parse "$index" "${line}";
  #parsing header lines
  elif [ $head -eq 0 ]; then
    #strip the carriage return and line feeds
    line=$( echo "$line" | tr -d "\r" );
    line=$( echo "$line" | tr -d "\n" );
    if [[ -z "$line" ]] && [[ $redirects -eq 0 ]]; then
      head=1;
      echo "" >> "${http[head.file]}";         
    elif [[ -z "$line" ]] && [[ $redirects -gt 0 ]]; then
      #echo "parsing next header...";
      index=$[index + 1];
      redirects=$[redirects - 1];
      echo "" >> "${http[head.file]}";
    else
      #append to the header file
      echo "$line" >> "${http[head.file]}";
      http.header.parse "$index" "$line";
    fi
  fi
}
