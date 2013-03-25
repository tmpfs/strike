require.once 'json';

taskinfo npm "Proxy to npm(1)";
tasks.npm() {
  local descriptor="${root}/package.json";  
  if [ ! -f "${descriptor}" ]; then
    console quit 1 "no %s package descriptor %s" "npm" "${descriptor}";
  fi
  if [ $# -eq 0 ]; then
    console quit 1 "no npm command specififed";
  fi
  local cmd="${1:-}";
  shift;
  local commands_namespace="npm.commands";
  if ! method.exists? "${commands_namespace}.${cmd}"; then
    console quit 1 "invalid %s command %s" "npm" "${cmd}";
  fi
  # always parse the json package descriptor
  json.parse < "$descriptor"; 
  local archive="${json_doc[name]}-${json_doc[version]}.tgz";
  delegate "${commands_namespace}" "${cmd}" "$@";
}

# PRIVATE TASK METHODS

# create the npm tarball and move to ${target}
npm.commands.pkg() {
  { npm pack && mv "${root}/${archive}" "${target}"; } \
    || console quit 1 "could not create archive %s" "${root}/${archive}";
}

# print the package information
npm.commands.print() {
  json.print;
}
