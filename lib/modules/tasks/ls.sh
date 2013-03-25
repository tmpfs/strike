taskinfo ls "List available tasks";
tasks.ls() {
  executable.validate egrep;
  local egrep="${executables[egrep]}";
  local methods=( $( method.list | $egrep "^tasks\.[a-zA-Z]+" ) );
  local m;
  for m in ${methods[@]}
    do
      # remove the prefix
      m=${m#tasks.};
      # ignore any constructor function, which is
      # not considered to be a task
      if [[ "$m" =~ \.initialize$ ]]; then continue; fi
      console print -- "%s" "$m";
      if $verbose; then
        if [ -n "${task_info[$m]:-}" ]; then
          printf "\t${task_info[$m]}\n" | expand -t 2 | fmt;
        fi
      fi
  done
}
