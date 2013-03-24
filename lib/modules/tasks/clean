taskinfo clean "Remove the target directory, use the --verbose option to list files as they are deleted";
tasks.clean() {
  # TODO: add support for finding nested `target`
  # TODO: directories and removing those too
  local rmopts="-rf"; 
  if $verbose; then
    rmopts="${rmopts}v";
  fi
  # this should never happen
  # as bake(1) always creates `target`
  # it's a just in case test
  if [ ! -d "${target}" ]; then
    console quit 1 -- "%s does not exist" "${target}";
  fi
  console info -- "rm ${rmopts} %s" "${target}";
  accepted() {    
    rm "${rmopts}" "${target}";
    if [ $? -gt 0 ]; then
      console quit $? -- "could not rm %s" "$rmopts" "$target";
    else
      console success;
    fi
  }
  rejected() {
    console quit 1 "aborted";
  }
  # cannot interact, just try to clean
  if [ ! -t 0 ] || [ ! -t 1 ]; then
    accepted;
    return 0;
  fi
  # confirmation prompt
  process_name="clean";
  console prompt --program "are you sure? (y/n)";
  prompt confirm --accepted=accepted --rejected=rejected;
}
