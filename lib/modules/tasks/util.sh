require.once opts/help;

declare -Ag task_info;
taskinfo(){
  local key="${1:-}";
  if [ -n "${key}" ]; then
    shift;
    task_info[$key]="$*";
  fi
}

taskman() {
  local key="${1:-}";
  local page="${2:-}";
  help.man.page "${key}" "${page}";
}
