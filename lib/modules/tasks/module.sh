taskinfo module "Multi-module task support";
tasks.module() {
  # list of modules
  local modules=();
  
  # list of patterns to ignore when searching for
  # sub modules
  local ignores=(
    "node_modules$"
  );
  
  if [ $# -eq 0 ]; then
    console quit 1 "no %s command specififed" "module";
  fi
  local cmd="${1:-}";
  shift;
  if ! method.exists? "module.${cmd}"; then
    console quit 1 "invalid %s command %s" "module" "${cmd}";
  fi
  # always attempt to find submodules
  module.find;
  delegate "module" "${cmd}" "$@";
}

# PRIVATE MODULE COMMAND METHODS

# list submodules
module.ls() {
  module.none.quit;
  local m;
  for m in "${modules[@]}"
    do
      console print "${m}";
  done
}

# marks a task as a delegate to sub-modules 
# USAGE: tasks.module delegate "$@";
module.delegate() {
  module.none.quit;  
  local info f;
  require.resolve "info" "3";
  local task_command="${info[3]}";
  
  # remove the method declaration from
  # the main `tasks` file
  method.remove "$task_command";
  for f in "${modules[@]}"
    do
      # ensure variables exposed are correct
      # for submodules
      root=$( dirname $f );
      target="${root}/target";
      tasks="$f";
      
      # source each submodule
      require "$f";
      
      # check the task command exists
      if ! method.exists? "${task_command}"; then
        console quit 1 "submodule %s does not declare %s" "$f" "$task_command";
      fi
      
      # try to invoke the command method in the submodule
      "${task_command}" "$@" \
        || console quit 1 "error invoking submodule task %s" "$task_command";
  done
}

# PRIVATE METHODS

# quit if there are no sub modules
module.none.quit() {
  if [ ${#modules[@]} -eq 0 ]; then
    console quit 1 -- "no modules found in %s" "${root}";
  fi
}

# determines if an ignore pattern matches
module.ignores?() {
  local ptn;
  for ptn in "${ignores[@]}"
    do
      if [[ "$d" =~ $ptn ]]; then
        return 0;
      fi
  done
  return 1;
}

# find submodules
module.find() {
  local d scan;
  for d in "${root}"/*
    do
      # never look in target
      if [ "${d}" == "${target}" ]; then
        continue;
      fi
      if module.ignores?; then
        continue;
      fi
      if [ -d "$d" ]; then
        scan=( $( find "${d}" -name "${tasks_file_name}" -type f ) );
        if [ ${#scan[@]} -gt 0 ]; then
          modules+=( "${scan[@]}" );
        fi
      fi
  done
}
