# main entry point
prompt() {
  if [ $# -eq 0 ]; then
    console quit 1 "too few options";
  fi
  local namespace="${FUNCNAME}.commands";
  local cmd="$1";
  shift;
  if ! method.exists? "${namespace}${delegate_delimiter}${cmd}"; then
    console quit 1 "invalid command %s" "$cmd";
  fi
  # value entered by user
  local value;
  # current command
  local current;
  local options;
  # list of competion functions
  declare -a completions;
  # configuration settings
  declare -A settings;
  settings[silent]=false;
  settings[multiline]=false;
  settings[execute]=false;
  settings[infinite]=false;
  settings[timeout]=0;
  settings[quit]="";
  settings[default]="";
  settings[selection]="";
  # custom data associated with the prompt
  settings[data.id]="";
  # boolean settings
  settings[boolean.strict]=false;
  settings[boolean.yes]="yes";
  settings[boolean.no]="no";
  settings[boolean.accepted]="";
  settings[boolean.rejected]="";
  # command callbacks
  settings[commands.before]="";
  settings[commands.response]="";
  settings[commands.timeout]="";
  settings[commands.accepted]="";
  settings[commands.rejected]="";
  settings[commands.validate]="";
  settings[commands.selection]="";
  settings[commands.selection.error]="";
  settings[commands.selection.range]="";
  # history control
  settings[hist.control]="erasedups:ignoredups";
  settings[hist.size]="500";
  settings[hist.filesize]="500";
  settings[hist.file]="";
  prompt.options.parse "$@";
  # try to create a history file when possible
  if [ -n "${settings[hist.file]}" ] \
    && [ ! -f "${settings[hist.file]}" ]; then
    touch "${settings[hist.file]}" \
      || console quit 1 "could not create %s" \
        "${settings[hist.file]}";
  fi
  delegate "${namespace}" "${cmd}" "$@";
}

# COMMANDS

# show a select menu
prompt.commands.select() {
  current="$FUNCNAME";
  options=( "$@" );
  prompt.trigger 'commands.before' "${settings[data.id]:-}";
  export PS3_ORIGINAL="${PS3:-}";
  if [ -n "${PS9:-}" ]; then
    export PS3='';
  fi
  if [ -z "${PROMPT_SELECTION[*]:-}" ]; then
    console warn "nothing to select";
    return 0;
  fi
  local selection=( "${PROMPT_SELECTION[@]:-}" );
  # NOTE: we show the select menu in this manner
  # NOTE: to prevent the select builtin from showing
  # NOTE: the prompt which does not support readline
  local menu=$( printf '' | select word in "${selection[@]:-}";
    do
      break;
  done )
  prompt.read false;
  local valid_regexp="^[0-9]+$";
  local maximum="${#selection[@]}";
  : $((maximum++));
  if [[ "$value" =~ $valid_regexp ]]; then
    if [ "$value" -gt 0 ] && [ "$value" -lt $maximum ]; then
      local index=$((value-1));
      local word="${selection[$index]}";
      prompt.trigger 'commands.selection' \
        "${word:-}" "${index:-}" "${value:-}" "${settings[data.id]:-}";
      prompt.trigger 'commands.response' \
        "${word:-}" "${settings[data.id]:-}";
    else
      prompt.trigger 'commands.selection.range' \
        "${value:-}" "${settings[data.id]:-}";
      prompt.commands.select;
    fi
  else
    prompt.trigger 'commands.selection.error' \
      "${value:-}" "${settings[data.id]:-}";
    prompt.commands.select;
  fi
  # restore PS3
  export PS3="${PS3_ORIGINAL:-}";
  unset PS3_ORIGINAL; 
}

# show a confirmation prompt
prompt.commands.confirm() {
  current="$FUNCNAME";
  options=( "$@" );
  local accept="${settings[boolean.yes]}";
  local reject="${settings[boolean.no]}";
  local accept_regexp="^${accept}$";
  local reject_regexp="^${reject}$";
  # comparse against first character
  if ! ${settings[boolean.strict]}; then
    accept="${accept:0:1}";
    reject="${reject:0:1}";
    # only needs to start with for non-strict mode
    accept_regexp="^${accept}";
    reject_regexp="^${reject}";
  fi
  prompt.read;
  local compare="${value}";
  # compare case-insensitive when
  # not running strict
  if ! ${settings[boolean.strict]}; then
    compare="${compare,,}";
  fi
  if [[ "$compare" =~ $accept_regexp ]]; then
    prompt.trigger 'commands.response' \
      true "${settings[data.id]:-}" "${value:-}";
    prompt.trigger 'commands.accepted' "${value:-}";
  elif [[ "$compare" =~ $reject_regexp ]]; then
    prompt.trigger 'commands.response' \
      false "${settings[data.id]:-}" "${value:-}";
    prompt.trigger 'commands.rejected' "${value:-}";
  else
    # show the prompt again
    # on invalid input
    prompt.commands.confirm;
  fi
}

# show a string prompt accepting
# any non-empty string value
prompt.commands.line() {
  current="$FUNCNAME";
  options=( "$@" );
  prompt.read;
  if [ -n "${value:-}" ]; then
    prompt.trigger 'commands.response' \
      "${value:-}" "${settings[data.id]:-}";
  else
    # show the prompt again
    # on empty input
    prompt.commands.line;
  fi
}

# INTERNAL

# determine if interactivity is possible
prompt.interactive?() {
  if [ -t 0 ]; then
    return 0;
  fi
  return 1;
}

# show a prompt using read
prompt.read() {
  export PROMPT_TIMEOUT=false;
  local before="${1:-true}";
  local hist_file="${settings[hist.file]}";
  # load history entries
  if [ -n "${hist_file:-}" ] && [ -f "${hist_file}" ]; then
    history -n "${hist_file}";
  fi
  if $before; then
    prompt.trigger 'commands.before' "${settings[data.id]:-}";
  fi
  if prompt.interactive?; then
    local read_options=( -e );
    if ! ${settings[multiline]}; then
      read_options+=( -r );
    fi
    if [[ "${settings[timeout]}" =~ ^[0-9]+$ ]] \
      && [ "${settings[timeout]}" -gt 0 ]; then
      read_options+=( -t "${settings[timeout]}" );
    fi
    if ${settings[silent]}; then
      read_options+=( -s );
    fi
    if [ -n "${PS9:-}" ]; then
      read_options+=( -p "${PS9}" );
    fi
    # bind tab key
    prompt.bind;
    prompt.before;
    while
      HISTSIZE="${settings[hist.size]}"
      HISTFILESIZE="${settings[hist.filesize]}";
      HISTFILE="${hist_file}";
      HISTCONTROL="${settings[hist.control]}";
      read "${read_options[@]}" value;
      export PROMPT_READ_EXIT_CODE=$?;
      do
        if [ -f "${HISTFILE}" ] \
          && [ -w "${HISTFILE}" ] \
          && ! ${settings[silent]} \
          && [ -n "${value}" ]; then
          history -s "$value";
          history -w "$HISTFILE";
        fi
        break;
    done
    if [ $PROMPT_READ_EXIT_CODE -gt 128 ]; then
      PROMPT_TIMEOUT=true;
      prompt.trigger 'commands.timeout' "${settings[data.id]:-}";
    fi
    prompt.after;
    # print additional newline in these situations
    if [ $PROMPT_READ_EXIT_CODE -gt 128 ] \
      || ${settings[silent]}; then
      printf '\n';
    fi
    if [ -z "${value}" ] && [ -n "${settings[default]}" ]; then
      value="${settings[default]}";
    fi
    # handle value validation
    if [ -n "${settings[commands.validate]}" ]; then
      prompt.trigger 'commands.validate' "${value}";
      if [ $? -gt 0 ]; then
        $current "${options[@]:-}";
        return 0;
      fi
    fi
    if [ -n "${settings[quit]}" ]; then
      if array.contains? "${value:-}" ${settings[quit]}; then
        settings[infinite]=false;
        settings[execute]=false;
        return 0;
      fi
    fi
    if ${settings[execute]}; then
      # NOTE: must run in a sub-shell
      ( /usr/bin/env bash -c "$value"; )
    fi
    if ${settings[infinite]} && method.exists? "$current"; then
      # ensure the repsonse command is triggered for
      # infinite prompts
      prompt.trigger 'commands.response' \
        "${value:-}" "${settings[data.id]:-}";
      $current "${options[@]:-}";
    fi
  fi
}

# responds to the tab key binding
prompt.completion() {
  COMP_CWORD=0;
  READLINE_WORD="";
  if [ -z "${READLINE_LINE:-}" ]; then
    COMP_WORDS=( "" );
  else
    # split out the line into words
    COMP_WORDS=( $READLINE_LINE );
    local i c;
    local word="";
    for((i = $READLINE_POINT;i > -1;i--))
      do
        c="${READLINE_LINE:$i:1}";
        # echo "got char $c";
        if [ -z "${word}" ] && [ "${c}" == ' ' ]; then
          console bell;
          return 0;
        fi
        if [ "${c}" != ' ' ]; then
          word="${c}${word}";
        fi
        if [ -n "${word}" ]; then
          if [ "${c}" == ' ' ]; then
            break;
          fi
        fi
    done
    # additional useful variable containing
    # the current word nearest the cursor position
    READLINE_WORD="${word}";
    local i;
    for i in "${!COMP_WORDS[@]}"
      do
        v="${COMP_WORDS[$i]}";
        if [ "${v}" == "${word}" ]; then
          COMP_CWORD="$i";
          break;
        fi
    done
  fi
  local length="${#completions[@]:-0}";
  if [ $length -gt 0 ]; then
    local func;
    for func in "${completions[@]:-}"
      do
        if method.exists? "${func}"; then
          "$func";
        fi
    done
  else
    # default completion
    COMPREPLY=( $( compgen -o "default" -o "bashdefault" "$READLINE_WORD" ) );
  fi
  if [ -z "${COMPREPLY:-}" ]; then
    console bell;
    return;
  fi
  # exact match - single completion
  if [ "${#COMPREPLY[@]:-0}" -eq 1 ]; then
    local completed="${COMPREPLY[0]}";
    local remainder="${completed#$READLINE_WORD}";
    READLINE_LINE="${READLINE_LINE:-}${remainder:-}";
    READLINE_POINT="${#READLINE_LINE}";
  # list of possible completions
  elif [ "${#COMPREPLY[@]:-0}" -gt 1 ]; then
    # we've got some completions
    # show the prompt
    # before listing completions
    prompt.faux;
    prompt.completion.print;
  fi
  unset IFS;
  unset COMPREPLY;
  unset COMP_CWORD;
  unset COMP_WORDS;
}

# show a faux prompt to mimic
# the current prompt
prompt.faux() {
  ( read -u 1 -ep "${PS9}" <<< "${READLINE_LINE:-}" );
}

# print the compreply
prompt.completion.print() {
  local IFS=$'\n';
  local reply="${COMPREPLY[*]:-}";
  local count=4;
  prompt.columns;
  printf -- "$reply" | pr -$count -t -w $COLUMNS -;
  unset IFS;
}

# calculate number of columns to
# use for printing COMPREPLY
prompt.columns() {
  local len=0;
  local padding=4;
  local v;
  for v in "${COMPREPLY[@]:-}"
    do
      if [ "${#v}" -gt $len ]; then
        len="${#v}";
      fi
  done
  len=$((len+padding));
  count=$((COLUMNS/len));
}

# bind to the tab key
prompt.bind() {
  set -o emacs;
  bind -x '"\t":"prompt.completion"';
}

# executed before showing a prompt
prompt.before() {
  # save stderr in file descriptor #7
  exec 7>&2;
  # redirect stderr to stdout
  exec 2>&1;
}

# executed after showing a prompt
prompt.after() {
  # restore stderr and close file descriptor #7
  if [ -f 7 ]; then
    exec 2>&7 7>&-;
  fi
}

# invoke a comamnd
prompt.trigger() {
  local key="${1:-}";
  local arguments=( "${@:2}" );
  # echo "trigger command with arguments: $arguments";
  if [ -n "$key" ]; then
    local cmd="${settings[$key]:-}";
    #echo "got cmd: $cmd";
    if [ -n "$cmd" ] && method.exists? "$cmd"; then
      "$cmd" "${arguments[@]:-}";
    fi
  fi
}

# handle option parsing
prompt.options.parse() {
  local optspec=":smei-:";
  local optchar val opt;
  OPTIND=0;
  while getopts "$optspec" optchar; do
      case "${optchar}" in
          -)
              case "${OPTARG}" in
          '')
            break;
            ;;
                  before=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.before]="${val}";
                      ;;
                  response=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.response]="${val}";
                      ;;
                  accepted=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.accepted]="${val}";
                      ;;
                  rejected=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.rejected]="${val}";
                      ;;
                  validate=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.validate]="${val}";
                      ;;
                  complete=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            completions+=( "${val}" );
                      ;;
                  hist-file=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[hist.file]="${val}";
                      ;;
                  id=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[data.id]="${val}";
                      ;;
                  timeout=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[timeout]="${val}";
                      ;;
                  quit=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[quit]="${val}";
                      ;;
                  default=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[default]="${val}";
                      ;;
                  select=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.selection]="${val}";
                      ;;
                  select-error=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.selection.error]="${val}";
                      ;;
                  select-range-error=*)
                      val=${OPTARG#*=};
                      opt=${OPTARG%=$val};
            settings[commands.selection.range]="${val}";
                      ;;
          silent)
            settings[silent]=true;
            ;;
          exec)
            settings[execute]=true;
            ;;
          infinite)
            settings[infinite]=true;
            ;;
          multiline)
            settings[multiline]=true;
            ;;
                  *)
                      if [ "$OPTERR" == 1 ] && [ "${optspec:0:1}" != ":" ]; then
                          echo "prompt: unknown option --${OPTARG}" >&2
                      fi
                      ;;
              esac;;
          s)
        settings[silent]=true;
              ;;
          m)
        settings[multiline]=true;
              ;;
          e)
        settings[execute]=true;
              ;;
          i)
        settings[infinite]=true;
              ;;
          *)
              if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" == ":" ]; then
                  echo "prompt: non-option '-${OPTARG}'" >&2
              fi
              ;;
      esac
  done
}
