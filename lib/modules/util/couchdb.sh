require.once net/http;
require.once net/url;

declare -g couchdb_verbose=false;
declare -g couchdb_verbose_background="black";
declare -g couchdb_session_login_auth_token="";

# > curl -vX POST $HOST/_session -H 'Content-Type: application/x-www-form-urlencoded' -d 'name=anna&password=secret'

# > curl -vX PUT $HOST/_all_dbs --cookie AuthSession=ZmZzeXM6NTBGNjdEOTY6vAyRr5A7XWPxDum-jkXglKKXgxU -H "X-CouchDB-WWW-Authenticate: Cookie" -H "Content-Type: application/x-www-form-urlencoded"
# {"ok":true}

# Set-Cookie: AuthSession=ZmZzeXM6NTBGNjdEOTY6vAyRr5A7XWPxDum-jkXglKKXgxU; Version=1; Path=/; HttpOnly

# centralized entry point for couchdb(3)
# http(3) requests so that it's easier to
# add before/after debugging statements
couchdb.run() {
  if $couchdb_verbose; then
    local verb="${1:-}";
    local url="${2:-}";
    # NOTE: must escape URL encoded values to prevent
    # NOTE: printf from interpreting them
    url="${url//%/%%/}";
    console info --prefix="[${verb}]" \
      --background0="${couchdb_verbose_background}" \
      -- "%s" "${url}";
  fi
  local opts=( "$@" );
  opts+=( "-H" "Content-Type: application/json" );

  # add session cookie authentication information
  if [ -n "${couchdb_session_login_auth_token:-}" ]; then
    opts+=( "-H" "X-CouchDB-WWW-Authenticate: Cookie" );
    opts+=( "-H" "Content-Type: application/x-www-form-urlencoded" );
    opts+=( "--cookie" "$couchdb_session_login_auth_token" );
  fi
  http.curl "${opts[@]}";
}

couchdb.session.login() {
  local host="${1:-}";
  local user="${2:-}";
  local pass="${3:-}";
  if [ -n "$host" ] && [ -n "$user" ] && [ -n "$pass" ]; then
    couchdb.run "POST" "${host}/_session" \
      "-H" "Content-Type: application/x-www-form-urlencoded" \
      "-d" "name=${user}&password=${pass}";
      
    # TODO: refactor to use http_headers array which will work when redirects
    # are in use
    local cookie="${http_header_0_set_cookie:-}";
    if [ -z "$cookie" ]; then
      console warn -- \
        "could not retrieve cookie header information for couchdb session login";
    else
      #AuthSession=ZmZzeXM6NTBGNjgwOEM6ROf3Gcfux_kfV_x3VDmRPCGaQ84; Version=1; Path=/; HttpOnly
      couchdb_session_login_auth_token="${cookie%%;*}";
      #couchdb_session_login_auth_token="${couchdb_session_login_auth_token#AuthSession=}";
      echo "got auth session token: $couchdb_session_login_auth_token";
    fi
    
    #echo "got set cookie header: $http_header_0_set_cookie";
  fi
}

# TODO: url encode database names so that slashes may be used

couchdb.tasks() {
  local host="${1:-}";
  couchdb.run "GET" "${host}/_active_tasks";
}

couchdb.stats() {
  local host="${1:-}";
  couchdb.run "GET" "${host}/_stats";
}

couchdb.log() {
  local host="${1:-}";
  local bytes="${2:-}";
  local url="${host}/_log";
  if [[ "${bytes}" =~ ^[0-9]+$ ]]; then
    url+="?bytes=${bytes}";
  fi
  couchdb.run "GET" "${url}";
}

couchdb.config.get() {
  local host="${1:-}";
  local section="${2:-}";
  local key="${3:-}";
  local url="${host}/_config";
  if [ -n "${section}" ]; then
    url+="/${section}";
  fi
  if [ -n "${key}" ]; then
    url+="/${key}";
  fi
  couchdb.run "GET" "${url}";
}

couchdb.config.rm() {
  local host="${1:-}";
  local section="${2:-}";
  local key="${3:-}";
  local url="${host}/_config";
  if [ -n "${section}" ]; then
    url+="/${section}";
  fi
  if [ -n "${key}" ]; then
    url+="/${key}";
  fi
  couchdb.run "DELETE" "${url}";
}

couchdb.config.set() {
  local host="${1:-}";
  local section="${2:-}";
  local key="${3:-}";
  local json="${4:-}";
  local url="${host}/_config";
  if [ -n "${section}" ]; then
    url+="/${section}";
  fi
  if [ -n "${key}" ]; then
    url+="/${key}";
  fi
  couchdb.run "PUT" "${url}" --data-binary "${json}";
}

couchdb.restart() {
  local host="${1:-}";
  couchdb.run "POST" "${host}/_restart";
}

couchdb.uuids() {
  local host="${1:-}";
  local count="${2:-}";
  local url="${host}/_uuids";
  if [[ "${count}" =~ ^[0-9]+$ ]]; then
    url+="?count=${count}";
  fi
  couchdb.run "GET" "${url}";
}

couchdb.db.list() {
  local host="${1:-}";
  couchdb.run "GET" "${host}/_all_dbs";
}

couchdb.db.purge() {
  local host="${1:-}";
  local db="${2:-}";
  url.encode "${db}" "db";
  couchdb.run "POST" "${host}/${db}/_purge";
}

couchdb.db.commit() {
  local host="${1:-}";
  local db="${2:-}";
  url.encode "${db}" "db";
  couchdb.run "POST" "${host}/${db}/_ensure_full_commit";
}

couchdb.db.changes() {
  local host="${1:-}";
  local db="${2:-}";
  url.encode "${db}" "db";
  couchdb.run "GET" "${host}/${db}/_changes";
}

couchdb.db.revslimit() {
  local host="${1:-}";
  local db="${2:-}";
  local amount="${3:-}";
  url.encode "${db}" "db";
  local url="${host}/${db}/_revs_limit";
  if [[ "${amount}" =~ ^[0-9]+$ ]]; then
    couchdb.run "PUT" "${url}" "-d" "${amount}";
  else
    couchdb.run "GET" "${url}";
  fi
}

couchdb.db.add() {
  local host="${1:-}";
  local db="${2:-}";
  url.encode "${db}" "db";
  couchdb.run "PUT" "${host}/${db}";
}

couchdb.db.rm() {
  local host="${1:-}";
  local db="${2:-}";
  url.encode "${db}" "db";
  couchdb.run "DELETE" "${host}/${db}";
}

couchdb.db.compact() {
  local host="${1:-}";
  local db="${2:-}";
  local design="${3:-}";
  url.encode "${db}" "db";
  local url="${host}/${db}/_compact";
  if [ -n "${design}" ]; then
    url+="/${design}";
  fi
  couchdb.run "POST" "${url}";
}

couchdb.db.cleanup() {
  local host="${1:-}";
  local db="${2:-}";
  url.encode "${db}" "db";
  couchdb.run "POST" "${host}/${db}/_view_cleanup";
}

couchdb.db.info() {
  local host="${1:-}";
  local db="${2:-}";
  url.encode "${db}" "db";
  couchdb.run "GET" "${host}/${db}";
}

couchdb.db.alldocs() {
  local host="${1:-}";
  local db="${2:-}";
  local querystring="${3:-}";
  url.encode "${db}" "db";
  local url="${host}/${db}/_all_docs"
  if [ -n "$querystring" ]; then
    url+="${querystring}";
  fi
  couchdb.run "GET" "${url}";
}

couchdb.doc.get() {
  local host="${1:-}";
  local db="${2:-}";
  local id="${3:-}";
  url.encode "${db}" "db";
  local url="${host}/${db}/${id}";
  couchdb.run "GET" "${url}";
}

couchdb.doc.rm() {
  local host="${1:-}";
  local db="${2:-}";
  local id="${3:-}";
  local rev="${4:-}";
  url.encode "${db}" "db";
  local url="${host}/${db}/${id}?rev=${rev}";
  couchdb.run "DELETE" "${url}";
}

couchdb.doc.head() {
  local host="${1:-}";
  local db="${2:-}";
  local id="${3:-}";
  url.encode "${db}" "db";
  local url="${host}/${db}/${id}";
  couchdb.run "GET" "${url}" --head;
}

couchdb.doc.save() {
  local host="${1:-}";
  local db="${2:-}";
  local doc="${3:-}";
  local id="${4:-}";
  url.encode "${db}" "db";
  if [ -f "${doc}" ]; then
    local url="${host}/${db}";
    local method="POST";
    if [ -n "${id}" ]; then
      url+="/${id}";
      method="PUT";
    fi
    couchdb.run "${method}" "${url}" \
      -# --data-binary "@${doc}";
  fi
}

# query a view document
couchdb.view() {
  local viewdoc="${1:-views}";
  local view="${2:-}";
  local querystring="${3:-}";
  local path="_design/${viewdoc}/_view/${view}";
  if [ -n "$querystring" ]; then
    path="${path}${querystring}";
  fi
  couchdb.run "GET" "${path}";
}
