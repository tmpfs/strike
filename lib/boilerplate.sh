set -o errtrace;
set -o nounset;

# walk parent hierarchy looking
# for the script
walk() {
  local name="${1:-}";
  local dir="$2";
  file="${dir}/${name}";
  while ! test -f "$file" && [ "$dir" != "/" ];
    do
      dir=$( dirname "$dir" );
      file="${dir}/${name}";
  done
}

# source the script
import() {
  local script="$1";
  . "${script}" "$@" 2>/dev/null \
    || { printf "fatal: failed to load %s\n" \
      "${script}" && exit 1; };
}

# resolve the script from a pre-defined
# set of paths
resolve() {
  local base="$1"; shift;
  local name="strike";
  local script="${name}.sh";
  local file="";
  local paths=(
    "${base}/../lib/${script}"
    "${base}/../node_modules/${name}/lib/${script}"
  );
  local f;
  for f in "${paths[@]}"
    do
      if [ -f "${f}" ]; then
        import "${f}"; return 0;
      fi
  done
  walk "lib/${script}" "$base";
  if [ -f "$file" ]; then
    import "${file}"; return 0;
  else
    walk "node_modules/${name}/lib/${script}";
    if [ -f "${file}" ]; then
      import "${file}"; return 0;
    fi
  fi
  printf "fatal: could not locate %s\n" "${script}"; exit 1;
}

# resolve executable directory
# including symbolic links and
# find strike.sh to source the
# library code
boilerplate() {
  local data=( $( caller 0 ) );
  local src="${data[2]}";
  local exedir="$( dirname "$src" )";
  while [ -h "$src" ]
    do
      src="$(readlink "$src")";
      [[ $src != /* ]] && src="$exedir/$src";
      exedir="$( cd -P "$( dirname "$src" )" && pwd )";
  done
  exedir="$( cd -P "$( dirname "$src" )" && pwd )";
  unset src;
  resolve "$exedir" "$@" \
    && method.remove \
      boilerplate \
      resolve \
      import \
      walk;
}
