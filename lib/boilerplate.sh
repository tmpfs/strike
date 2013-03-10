set -o errtrace;
set -o nounset;

# resolve executable directory
# including symbolic links and
# find strike.sh to source the
# library code
boilerplate() {
  resolve() {
    local base="$1"; shift;
    local name="strike";
    local script="${name}.sh";
    local paths=(
      "${base}/../lib/${script}"
      "${base}/../node_modules/${name}/lib/${script}"
    );
    local f;
    for f in "${paths[@]}"
      do
        if [ -f "${f}" ]; then
          . "${f}" "$@" 2>/dev/null \
            || { printf "fatal: failed to load %s\n" \
              "${script}" && exit 1; };
          return 0;
        fi
    done
    printf "fatal: could not locate %s\n" "${script}"; exit 1;
  }
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
    && method.remove $FUNCNAME resolve;
}
