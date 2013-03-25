# generate a checksum using either
# shasum or sha1sum
checksum.sha() {
  local algorithm="512";
  if [[ "${1:-}" =~ ^[0-9]+$ ]]; then
    algorithm="$1";
    shift;
  fi
  local target="sha${algorithm}sum";
  local binaries=( shasum "${target}" );
  executable.validate --test "${binaries[@]}";
  local exe="${executables[shasum]}";
  # --portable --binary ?
  local opts=( --algorithm $algorithm );
  if [ -z "${exe}" ]; then
    exe="${executables[${target}]}";
    opts="";
  fi
  if [ -z "${exe}" ]; then
    console warn "cannot generate sha checksum missing one of %s" \
      "${binaries[*]}";
    return 1;
  else
    "$exe" ${opts[@]:-} $@;
    return $?;
  fi
}

# generate a md5 checksum using either
# md5 (BSD) or md5sum (Linux)
checksum.md5() {
  local file="${1:-}";
  if [ -z "$file" ]; then
    return 1;
  fi
  local binaries=( md5 md5sum );
  executable.validate --test "${binaries[@]}";
  if [ -n "${executables[md5]}" ]; then
    ${executables[md5]} -q "$file";
  elif [ -n "${executables[md5sum]}" ]; then
    local parts=( $( ${executables[md5sum]} "$file" ) );
    printf "${parts[0]}\n";
  fi
}