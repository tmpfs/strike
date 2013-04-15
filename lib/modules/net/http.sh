require net/url;

process.directory http;

declare -Ag http;
http[home]=~/.${framework}/http;
http[writeout]="%{http_code}\n%{url_effective}\n%{time_total}\n%{num_redirects}\n%{filename_effective}\n";

#declare -g http_home=~/.${framework}/http;
declare -g http_head_file="${http[home]}/http.head";
declare -g http_body_file="${http[home]}/http.body";
declare -g http_exit_file="${http[home]}/http.exit";
declare -g http_trace_ascii_file="${http[home]}/http.trace.ascii";
declare -g http_head_dump_file="${http[home]}/http.head.dump";
declare -g http_config_dir="${http[home]}/config";
declare -g http_config_file="${http[home]}/http.config";
declare -g http_stderr_file="${http[home]}/http.stderr";
declare -g http_stdout_file="${http[home]}/http.stdout";
declare -g http_config_name="";
declare -g http_base_url="";
declare -Ag http_res_headers;
declare -Ag http_req_headers;
declare -g http_redirects=true;

# determines whether curl(1) stderr output is also
# printed to the screen
declare -g http_print_stderr="";

# determines whether to quit when curl(1)
# returns a non-zero exit code, set to a
# non-blank string to switch on
declare -g http_strict="";

declare -Ag http_request_headers;

declare -ag http_command_options;
http_command_options=();

# have to do this in two steps for arrays as
# direct assignment will cause the http_files array not
# to be available inside function definitions
declare -ag http_files;
http_files=(
  "$http_head_file"
  "$http_exit_file"
  "$http_trace_ascii_file"
  "$http_head_dump_file"
  "$http_stderr_file"
  "$http_stdout_file"
);

declare -g http_auth_user="";
declare -g http_auth_pass="";

http() {
  executable.validate curl tee;
  local commands_namespace="http.commands";
  local cmd="${1:-}";
  shift;
  if ! method.exists? "${commands_namespace}.$cmd"; then
    console quit 1 -- "unknown http command %s" "$cmd";
  fi  
  delegate "${commands_namespace}" "$cmd" "$@";
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

http.config.save() {
  local id="${1:-}";
  if [ ! -z "$id" ] && [ -f "$http_config_file" ]; then
    if [ ! -d "$http_config_dir" ]; then
      mkdir -p "$http_config_dir";
    fi
    local configfile="${http_config_dir}/${id}"
    copy "$http_config_file" "$configfile" \
      || console quit 1 -- "could not copy config file to %s" "$configfile";
  fi
}

http.clean() {
  local f;
  for f in ${http_files[@]}
    do
      rm -fv "$f";
  done
}

http.initialize() {
  if [ ! -d "${http[home]}" ]; then
    mkdir -p "${http[home]}";
  fi
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

  # create an empty body file
  #echo -ne "" >| "$http_body_file";
  
  #ensure we unset all variables before the next request
  #TODO: move to a method for unsetting by group
  for opt in ${!http_response_*}
    do
      unset "$opt";
  done
  
  #echo "$FUNCNAME: ${#runopts[@]} : ${runopts[@]}";
    
  # redirect stderr with tee, useful for also
  # displaying file download progress
  if [ ! -z "$http_print_stderr" ]; then
    $cmd "${runopts[@]}" 2>| >($tee "$http_stderr_file" >&2) 1>| "$http_stdout_file" || echo -n "$?" >> "$http_exit_file";  
  # not redirecting stderr to screen as well
  # so just send to the file
  else
    $cmd "${runopts[@]}" 2>| "$http_stderr_file" 1>| "$http_stdout_file" || echo -n "$?" >> "$http_exit_file";
  fi
  
  # get the write out results
  results=( $( < "$http_stdout_file" ) );
  
  # echo "got results: ${results[@]}";
  
  http_exit_code=0;
  if [ -f "$http_exit_file" ]; then
    http_exit_code=`cat "$http_exit_file"`;
    http_exit_code=${http_exit_code:-0};
  fi
  
  # echo "got curl exit code: $http_exit_code";
  
  if [ ${#results[@]} -gt 2 ]; then
    http_response_status="${results[0]}";
    http_response_url="${results[1]}";
    http_response_time_total="${results[2]}";
    http_response_num_redirects="${results[3]:-0}";
  fi
  
  if [ ! -z "$http_config_name" ]; then
    http.config.save "$http_config_name";
  fi
  
  if [ "$http_exit_code" != "0" ]; then
    if [ ! -z "$http_strict" ]; then
      if [ -f "$http_stderr_file" ]; then
        console error -- "$( cat $http_stderr_file )";
      fi
      console quit $http_exit_code -- \
        "curl exited with non-zero status code (%s)" "$http_exit_code";
    else
      if [ -f "$http_stderr_file" ]; then
        console error -- "$( cat $http_stderr_file )";
      else
        console error -- \
          "curl exited with non-zero status code (%s)" "$http_exit_code";
      fi
    fi
  fi
  
  if [ -f "$http_body_file" ] && [ "$http_exit_code" == "0" ]; then
    # parse response headers into variable data
    __http_response_parse "${http_head_dump_file}";
  fi
}

http.curl() {
  local method="${1:-GET}"; shift;
  local path="${1:-}"; shift;
  
  #remaining custom options
  local opts=( "$@" );
  
  local url="$path";
  if [ ! -z "$http_base_url" ]; then
    #strip any leading slash on path
    path=${path#/};
    url="${http_base_url}/${path}";
  fi
  
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

  if [ "${http_redirects}" == true ]; then
    runopts+=(--location);
  fi
  
  if [ -n "$http_auth_user" ] && [ -n "$http_auth_pass" ]; then
    runopts+=( "--user" "${http_auth_user}:${http_auth_pass}" );
  fi
  
  local hname hvalue;
  for hname in ${!http_request_headers[@]}
    do
      hvalue=${http_request_headers[$hname]};
      # echo "adding request header: $hname::$hvalue";
      runopts+=( "--header" "${hname}: $hvalue" );
  done
  
  runopts+=(
    "--dump-header"
    "$http_head_dump_file"
    "--trace-ascii"
    "$http_trace_ascii_file"
    "--write-out"
    "${http[writeout]:-}"
  );
  
  # add additional command options
  set +o nounset;
  for hvalue in ${http_command_options[@]}
    do
      #echo "got http_command_options : $hvalue";
      runopts+=( "$hvalue" );
  done
  set -o nounset;

  #pass in custom opts
  if [ ${#opts[@]} -gt 0 ]; then
    #echo "adding custom options... ${opts[@]}";
    runopts+=( "${opts[@]}" );
  fi
  
  if ! array.contains? "-#" "${runopts[@]}" \
    || ! $http_print_stderr; then
    runopts+=(
      "--silent"
    );
  fi

  local body="${http_body_file}";
  if ! array.contains? "--output" "${runopts[@]}"; then
    if array.contains? "--head" "${runopts[@]}"; then
      http_body_file="${http_head_file}";
    fi
    runopts+=( --output "$http_body_file" );
  fi

  runopts=( "${runopts[@]}" --url "$url" );
  
  # echo "runopts: ${runopts[@]}";
  
  http_request_method="${method}";
  
  #write out the options used as a config file
  local http[config]=$( http.config "${runopts[@]}" );
  #http.config "${runopts[@]}";

  echo "${http[config]}"; exit 0;

  http.curl.execute "${runopts[@]}";
  http_body_file="${body}";
}

######################################################################
#
# Adds a command line option to be passed on when executing curl.
#
# $1  The option name.
# $2  The option value.
#
######################################################################
http.option.add() {
  local name=${1:-};
  local value=${2:-};
  if [ ! -z "$name" ] && [ ! -z "$value" ]; then
    http_command_options+=( "$name" );
    http_command_options+=( "$value" );
  fi
}

http.request.add.header() {
  local name="$1";
  local value="${2:-}";
  local hname hvalue;
  # only a single parameter so parse the header out
  if [ -z "$value" ]; then
    hname="${name%: ?*}";
    hvalue="${name#*:}";
  fi
  string.ltrim "$hvalue";
  hvalue="$_result";
  http_request_headers[$hname]="$hvalue";
}

######################################################################
#
# PRIVATE METHODS
#
######################################################################
http.config() {
  #echo "writing config with options: ${@}";
  
  #local f="$http_config_file";
  
  #empty the config file
  #echo -n >| "$f";
  
  local opts=( "$@" );
  local l=$#;
  local i val next;
  for((i = 0;i < l;i++))
    do
      val=${opts[$i]};
      next=${opts[i+1]:-};
      #echo "got opt: $i .. $val";
      # got more options to deal with 
      if [ ! -z "$next" ]; then
        #echo "got next.. $next";
        if [[ ! "$next" =~ ^--[a-z] ]]; then
          # echo "got next value with :: $next";
          echo "$val=\"$next\"";
          i=$[i + 1];
          continue;
        else
          echo "$val";
        fi
      fi
  done
}

__http_response_parse_status() {
  local raw="${@:2}";
  
  local index="$1";
  shift;

  if [ "$index" -eq "$http_response_num_redirects" ]; then
    http_res_status="${raw}";
  fi
  
  # echo "got response raw : $raw";
  # echo "got response index : $index";
  
  local opts=();
  for opt in ${@}
    do
      # echo "got opt : $opt";
      #TODO : change this to += 
      opts=( "${opts[@]:-}" "$opt" );
  done
  
  eval "export http_header_${index}_raw='${raw}'";
  #skip the first empty element in the array
  export "http_header_${index}_http="${opts[1]:-}"";
  export "http_header_${index}_status="${opts[2]:-}"";
  export "http_header_${index}_message="${opts[3]:-}"";
  
  # echo "opts length: ${#opts[@]}";
  # echo "[__http_response_parse_status] : ${http_response_header_raw}";
  # echo "[http_response_header_http] : ${http_response_header_http}";
  # echo "[http_response_header_status] : ${http_response_header_status}";
  # echo "[http_response_header_message] : ${http_response_header_message}";
}

__http_parse_header() {
  #echo "__http_parse_header: $1 : $2";
  
  local index="$1";
  local name="${2%: ?*}";
  local value="${2#*:}";

  # raw header information for final
  # set of headers
  if [ "$index" -eq "$http_response_num_redirects" ]; then
    http_res_headers["${name}"]="${value}";
  fi
  
  #convert hyphens to underscores
  name="${name//-/_}";
  
  #lowercase name
  name=${name,,};
  
  #strip leading whitespace
  string.ltrim "$value";
  value="$_result";
  
  # echo "got name: $name";
  # echo "got value: $value";
  
  #TODO: only export on the last header set received
  export "http_header_${index}_${name}=${value}";
}

__http_response_parse() {
  declare -g http_res_status="";
  declare -g http_req_status="";

  unset http_res_headers;
  declare -Ag http_res_headers;

  unset http_req_headers;
  declare -Ag http_req_headers;
  http.req.headers;

  # number of redirects corresponds to the number of headers to parse
  local redirects=${http_response_num_redirects:-0};
  local index=0;
  local output="$1";
  local head=0;
  while IFS= read -r line
    do
      __http.line;
  done < "$output";
  # process last line
  if [ -n "$line" ]; then __http.line; fi
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
  done < "${http_trace_ascii_file}";
}

__http.line() {
  #parse the HTTP declaration
  if [[ "$line" =~ ^HTTP/1.[01] ]]; then
    __http_response_parse_status "$index" "${line}";
  #parsing header lines
  elif [ $head -eq 0 ]; then
    #strip the carriage return and line feeds
    line=`echo "$line" | tr -d "\r"`;
    line=`echo "$line" | tr -d "\n"`;
    if [[ -z "$line" ]] && [[ $redirects -eq 0 ]]; then
      head=1;
      echo "" >> "$http_head_file";         
    elif [[ -z "$line" ]] && [[ $redirects -gt 0 ]]; then
      #echo "parsing next header...";
      index=$[index + 1];
      redirects=$[redirects - 1];
      echo "" >> "$http_head_file";
    else
      #append to the header file
      echo "$line" >> "$http_head_file";
      __http_parse_header "$index" "$line";
    fi
  fi
}
