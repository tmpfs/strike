
# TODO: test and document this module
function inet.up? {
  inet.ping? "$@";
}

function inet.dns? {
  executable.validate host;
  local host hosts=(
    "google.com"
    "yahoo.com"
    "stackoverflow.com"
  );
  set +e; 
  local code=0; 
  for host in ${hosts[@]}
    do
      "${executables[host]}" "$host" > /dev/null 2>&1;
      : $((code+=$?));
      #echo "host result: $code";
  done
  return $code;
}

function inet.ping? {
  executable.validate ping;
  local host hosts=(
    "google.com"
    "yahoo.com"
    "stackoverflow.com"
  );
  set +e;
  local code=0;
  for host in ${hosts[@]}
    do
      #echo "${executables[ping]} -c1 $host";
      "${executables[ping]}" -c1 "$host" > /dev/null 2>&1
      : $((code+=$?));
      #echo "ping result: $code";
  done
  # echo "returning code : $code";
  return $code;
}