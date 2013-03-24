taskinfo expand "Replace tabs with spaces in files";
tasks.expand() {
  local files=();
  local tabstops=2;
  tabstops expand $@;
}

taskinfo unexpand "Replace spaces with tabs in files";
tasks.unexpand() {
  local files=();
  local tabstops=2;
  tabstops unexpand $@;
}

tabstops() {
  local name="$1"; shift;
  local execute="${name}";
  if [ $# -eq 0 ]; then
    console quit 1 -- "too few options";
  fi
  local opts=( $@ );
  local i opt val length=${#opts[@]};
  for((i = 0;i < $length;i++))
    do
      opt="${opts[$i]}";
      case "${opt}" in
        -t )
          shift;
          if [ $i -eq $((length-1))  ]; then
            console quit 1 -- "no tab stops value specified";
          fi
          val="${opts[$((i+1))]}";
          if [[ ! "$val" =~ ^[0-9]+$ ]]; then
            console quit 1 -- "tab stops must be numeric";
          fi
          tabstops="${val}";
          ;;
        * )
          if [ -f "${opt}" ]; then
            files+=( "${opt}" );
          elif [ -d "${opt}" ]; then
            files+=( $( find "${opt}" -type f ) );
          fi
          ;;
      esac
  done
  if [ ${#files[@]} -eq 0 ]; then
    console quit 1 -- "no files found";
  fi
  execute+=" -t ${tabstops}";
  if ${platforms[linux]} && [ "${name}" == "expand" ]; then
    execute+=" -i";
  fi
  console info "tab stops %s" "${tabstops}";
  
  local IFS=$'\n';
  echo "${files[*]}";
  unset IFS;

  rejected() {
    console quit 1 -- "aborted";
  }

  # TODO: add exit trap to ensure temp file is removed
  accepted() {
    local temp=$( mktemp -t "${process_name}" );
    $verbose && console info -- "temp file is %s" "${temp}";
    local file contents;
    local i length="${#files[@]}";
    for((i = 0;i < $length;i++))
      do
        file="${files[$i]}";
        console info -- "replace in %s" "${file}";
        if $verbose; then
          console info "%s %s >| %s" "${execute}" "${file}" "${temp}";
        fi
        $execute "${file}" >| "${temp}";
        if $verbose; then
          console info "cp -f %s %s" "${temp}" "${file}";
        fi
        cp -f "${temp}" "${file}";
    done
    rm "${temp}";
  }

  process_name="${name}";
	console prompt --program \
    "replace in %s file(s), are you sure? (y/n)" \
    "${#files[@]}";
	prompt confirm --accepted=accepted --rejected=rejected;
}
