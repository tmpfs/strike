# TODO: move to global variables?
declare -gx process_strict="";
declare -g process_debug="";
declare -g process_test="";
declare -g process_lock="";
declare -g process_pid="";
declare -g process_tmp_dir="";

# TODO: add the process.use "debug"
# to force console error to always throw
# a stack trace

# POSIX signals
# 
# The list below documents the signals that are specified by the Single Unix Specification.[1] All signals are defined as macro constants in <signal.h> header file. The name of the macro constant consists of "SIG" prefix and several characters that identify the signal. Each macro constant expands into an integral number; these numbers can vary across platforms.
# SIGABRT
# The SIGABRT signal is sent to a process to tell it to abort, i.e. to terminate. The signal can only be initiated by the process itself when it calls abort function of the C Standard Library.
# SIGALRM, SIGVTALRM and SIGPROF
# The SIGALRM, SIGVTALRM and SIGPROF signal is sent to a process when the time limit specified in a call to a preceding alarm setting function (such as setitimer elapses. SIGALRM is sent when real or clock time elapses. SIGVTALRM is sent when CPU time used by the process elapses. SIGPROF is sent when CPU time used by the process and by the system on behalf of the process elapses.
# SIGBUS
# The SIGBUS signal is sent to a process when it causes a bus error. The conditions that lead to the signal being raised are, for example, incorrect memory access alignment or non-existent physical address.
# SIGCHLD
# The SIGCHLD signal is sent to a process when a child process terminates, is interrupted, or resumes after being interrupted. One common usage of the signal is to instruct the operating system to clean up the resources used by a child process after its termination without an explicit call to the wait system call.
# SIGCONT
# The SIGCONT signal instructs the operating system to restart a process previously paused by the SIGSTOP or SIGTSTP signal. One important use of this signal is in job control in the Unix shell.
# SIGFPE
# The SIGFPE signal is sent to a process when it executes an erroneous arithmetic operation, such as division by zero.
# SIGHUP
# The SIGHUP signal is sent to a process when its controlling terminal is closed. It was originally designed to notify the process of a serial line drop. In modern systems, this signal usually means that controlling pseudo or virtual terminal has been closed.[2]
# SIGILL
# The SIGILL signal is sent to a process when it attempts to execute a malformed, unknown, or privileged instruction.
# SIGINT
# The SIGINT signal is sent to a process by its controlling terminal when a user wishes to interrupt the process. This is typically initiated by pressing Control-C, but on some systems, the "delete" character or "break" key can be used.[3]
# SIGKILL
# The SIGKILL signal is sent to a process to cause it to terminate immediately. In contrast to SIGTERM and SIGINT, this signal cannot be caught or ignored, and the receiving process cannot perform any clean-up upon receiving this signal.
# SIGPIPE
# The SIGPIPE signal is sent to a process when it attempts to write to a pipe without a process connected to the other end.
# SIGQUIT
# The SIGQUIT signal is sent to a process by its controlling terminal when the user requests that the process perform a core dump.
# SIGSEGV
# The SIGSEGV signal is sent to a process when it makes an invalid virtual memory reference, or segmentation fault.
# SIGSTOP
# The SIGSTOP signal instructs the operating system to stop a process for later resumption.
# SIGTERM
# The SIGTERM signal is sent to a process to request its termination. Unlike the SIGKILL signal, it can be caught and interpreted or ignored by the process. This allows the process to perform nice termination releasing resources and saving state if appropriate.
# SIGTSTP
# The SIGTSTP signal is sent to a process by its controlling terminal to request it to stop temporarily. It is commonly initiated by the user pressing Control-Z. Unlike SIGSTOP, the process can register a signal handler for or ignore the signal.
# SIGTTIN and SIGTTOU
# The SIGTTIN and SIGTTOU signals are sent to a process when it attempts to read or write respectively from the tty while in the background. Typically, this signal can be received only by processes under job control; daemons do not have controlling terminals and should never receive this signal.
# SIGUSR1 and SIGUSR2
# The SIGUSR1 and SIGUSR2 signals are sent to a process to indicate user-defined conditions.
# SIGPOLL
# The SIGPOLL signal is sent to a process when an asynchronous I/O event occurs.
# SIGSYS
# The SIGSYS signal is sent to a process when it passes a bad argument to a system call.
# SIGTRAP
# The SIGTRAP signal is sent to a process when a condition arises that a debugger has requested to be informed of — for example, when a particular function is executed, or when a particular variable changes value.
# SIGURG
# The SIGURG signal is sent to a process when a socket has urgent or out-of-band data available to read.
# SIGXCPU
# The SIGXCPU signal is sent to a process when it has used up the CPU for a duration that exceeds a certain predetermined user-settable value. [4] The arrival of a SIGXCPU signal provides the receiving process a chance to quickly save any intermediate results and to exit gracefully, before it is terminated by the operating system using the SIGKILL signal.
# SIGXFSZ
# The SIGXFSZ signal is sent to a process when it grows a file larger than the maximum allowed size.
# SIGRTMIN to SIGRTMAX
# The SIGRTMIN to SIGRTMAX signals are intended to be used for user-defined purposes. They are real-time signals.

# man signal
# NOTE: signal `emt` is not available on centos 6.3
# NOTE: signal `info` is not available on centos 6.3
declare -ag process_signals;
process_signals=(
  hup
  int
  quit
  ill
  trap
  abrt
  fpe
  kill
  bus
  segv
  sys
  pipe
  alrm
  term
  urg
  stop
  tstp
  cont
  chld
  ttin
  ttou
  io
  xcpu
  xfsz
  vtalrm
  prof
  winch
  usr1
  usr2
);

# bash specific signals
process_signals+=( debug err exit );

declare -Ag process_signal_callbacks;

declare -Ag process_time;
process_time[start]=`date +%s`;

# store a boolean of whether we are looping as a daemon
declare -g process_loop=false;

#  TODO: add process.fork to run a process in the background and maintain a list of pids ? see jobs

#shopt -s checkwinsize;

function process.initialize {
  
  process.lock.test;
  
  # initialize registry of signal
  # callback methods
  local signal;
  for signal in ${process_signals[@]}
    do
      process_signal_callbacks["$signal"]="";
  done
  
  # echo "PID IS: $$";
  # # send SIGWINCH
  # # so that COLUMNS is set correctly
  # kill -28 $$;
  # echo "after sigwinch: ${COLUMNS:-}";
  
  # ( printf '' | select word in a b c;
  #   do
  #     break;
  # done )
  
  #echo "after sigwinch: ${COLUMNS:-}";
}

# is this process running in the context
# of the main library code
process.lib?() {
  if [ "${process_dirs[root]}" == "${library_dirs[root]}" ]; then
    return 0;
  fi
  return 1;
}

process.use() {
  while [ $# -gt 0 ];
    do
      local val="${1:-}";
      if [ "$val" == "strict" ]; then
        process_strict="on";
        # TODO: make these options an array
        set -o errtrace;
        set -o nounset;
        set -o noclobber;
      elif [ "$val" == "debug" ]; then
        process_debug="on";
      elif [ "$val" == "test" ]; then
        process_test="on";
      fi
      shift;
  done
}

# create process data directory
# if it does not exist
process.directory() {
  local name="${1:-}";
  local dir="${process_dirs[data]}";
  if [ -n "${name}" ]; then
    dir=~/.${framework}/"${name}";
  fi
  if [ ! -d "${dir}" ]; then
    mkdir -p "${dir}" \
      || console quit 1  -- "could not create %s" \
        "${dir}";
  fi
}

# retrieves the process uptime in seconds
process.uptime() {
  local start=${process_time[start]};
  local now=`date +%s`;
  local uptime=$(( $now - $start ));
  _result="$uptime";
}

# determine if we are running in debug mode
function process.debug? {
  test -n "$process_debug";
}

# determine if we are running in strict mode
function process.strict? {
  test -n "$process_strict";
}

# determine if we are running in test mode
function process.test? {
  test -n "$process_test";
}

# switch off debug mode
function process.debug! {
  process_debug="";
}

# switch off strict mode
function process.strict! {
  process_strict="";
  set +o errtrace;
  set +o nounset;
  set +o noclobber;
}

# switch off test mode
function process.test! {
  process_test="";
}

# TODO: allow this directory to be specified !

# set or gets the directory for process temporary files
function process.tmp.dir {
  if [ $# -eq 0 ]; then
    if [ -z "$process_tmp_dir" ]; then

      if [ -n "${TMPDIR:-}" ] \
        && [ -d "${TMPDIR}" ] \
        && [ -w "${TMPDIR}" ]; then
        _result="$TMPDIR";
        return 0;
      fi

      # TODO: change this to use *mktemp*
      # put the tmp directory in the library directory
      # so as not to pollute project directories
      local dir="${library_dirs[root]}/tmp";
      if [ ! -d "$dir" ] ;then
        mkdir -p "$dir" || console quit 1 "could not create temporary directory %s" "$dir";
      fi
      _result="$dir";
    else
      _result="$process_tmp_dir";
    fi
  else
    process_tmp_dir="$1";
  fi
}

# does nothing, use during development to prevent
# errors from empty conditionals, functions etc
function process.noop {
  return 0;
}

######################################################################
#
# SIGNAL PUBLIC METHODS
#
######################################################################

# add a callback method for signal(s)
function process.signal.on {
  local method="${1:-process.trap}";
  local signal;
  if ! method.exists? "$method"; then
    console warn "%s cannot add non-existent callback method %s" "$FUNCNAME" "$method";
  else
    # got some signals specified
    if [ $# -gt 1 ]; then
      # remove the method reference $1
      shift;
      # process the signal definitions
      while [ $# -gt 0 ];
        do
          signal="$1";
          # validate the signal is recognized         
          if process.signal.valid? "$signal"; then
            # add the callback method
            # echo "using signal: $signal : ${!process_signal_callbacks[@]}";
            # console throw;
            process_signal_callbacks["$signal"]="${process_signal_callbacks["$signal"]} ${method}";
            # remove a leading space delimiter
            process_signal_callbacks["$signal"]="${process_signal_callbacks["$signal"]# }";
          else
            console warn "%s invalid signal %s" "$FUNCNAME" "$signal";
          fi
          # process next signal name
          shift;
      done
    else
      console warn "%s no signals specified" "$FUNCNAME";
    fi
  fi
}

# determine if a signal name is valid
function process.signal.valid? {
  array.contains? "$1" ${process_signals[@]};
  return $?;
}

# remove a callback method(s) for a signal
function process.signal.off {
  local method="${1:-process.trap}";
  local signal callback i;
  
  declare -a callbacks;
  
  # TODO: work out why the iterator is failing?
  # iterator() {
  #   local key="$1" value="$2" index="$3";
  #   echo "iterator: $key : $value : $index";
  # }
  
  # got some signals specified
  if [ $# -gt 0 ]; then
    # remove the method reference $1
    shift;
    # process the signal definitions
    while [ $# -gt 0 ];
      do
        signal="$1";
        callbacks=( ${process_signal_callbacks["$signal"]} );
        
        for((i = 0;i < ${#callbacks[@]};i++))
          do
            callback="${callbacks[$i]}";
            if [ "$method" == "$callback" ]; then
              unset callbacks[$i];
              process_signal_callbacks["$signal"]="${callbacks[*]}";
              break;
            fi
        done
        
        # if callbacks are empty switch off signal ???
        
        # process next signal name
        shift;
    done
  else
    console warn "%s no signals specified" "$FUNCNAME";
  fi
  
  # clean up the iterator
  #method.remove "iterator";
}

# trigger callback(s) for signal(s) 
function process.signal.trigger {
  local signal callbacks method;
  while [ $# -gt 0 ];
    do
      signal="$1";
      callbacks=( ${process_signal_callbacks["$signal"]} );
      for method in ${callbacks[@]}
        do
          if method.exists? "$method"; then
            "$method";
          fi
      done
      shift;
  done
}

# print callbacks for signal(s)
function process.signal.print {
  local signal callbacks;
  while [ $# -gt 0 ];
    do
      signal="$1";
      callbacks=( "${process_signal_callbacks["$signal"]}" );
      console info "%s > %s" "$signal" "${callbacks[*]}";
      shift;
  done
}

# list callbacks for signal(s)
function process.signal.list {
  local signal callbacks=();
  while [ $# -gt 0 ];
    do
      signal="$1";
      callbacks+=( "${process_signal_callbacks["$signal"]}" );
      shift;
  done
  _result="${callbacks[*]}";
}

# switch on a trap
function process.on {
  local signal;
  while [ $# -gt 0 ];
    do
      signal="${1,,}";
      trap "__process.trap $? $signal" $signal;
      shift;
  done
}

# switch off a trap
function process.off {
  local signal;
  while [ $# -gt 0 ];
    do
      signal="${1,,}";
      trap - $signal;
      shift;
  done
}

######################################################################
#
# DAEMON PUBLIC METHODS
#
######################################################################

# determine if the process is running as a daemon
function process.daemon? {
  if [ "$process_loop" == true ]; then
    return 0;
  fi
  return 1;
}

# start this process running as a daemon
function process.daemon.start! {
  local method="${1:-process.loop}";
  if method.exists? "$method"; then
    process_loop=true;
    __process.daemonize "$method";
  else
    console warn "attempt to daemonize with no callback method %s" "$method";
  fi
}

# stop this process running as a daemon
function process.daemon.stop! {
  # switch the loop off
  process_loop=false;
}

######################################################################
#
# LOCK FILE PUBLIC METHODS
#
######################################################################

# determine if we are running as a singleton with a lock file
function process.lock? {
  test -n "$process_lock";
}

# retrieve the name of the lock file for this process
function process.lock.name {
  _result="${process_name}.lock";
}

# retrieve the path to the lock file for this process
function process.lock.file {
  process.tmp.dir;
  local process="$_result";
  process.lock.name;
  _result="${process}/${_result}";
}

# check for an existing lock file
# and quit if it exists
function process.lock.test {
  process.lock.file;
  local file="$_result";
  if [ -f "$file" ]; then
    console quit 1 "lock file %s exists" "$file";
  fi  
}

# flag this program as using a lock file
function process.lock.use! {
  if [ $# -eq 0 ]; then
    # switch on trapping exit so we can clean up
    # the lock file using the private handler
    process.signal.on __process.lock.clean exit;
    process.on exit;
  
    process_lock="on";
    __process.lock.write;
  else
    process_lock="";
    # clean the lock file immediately
    __process.lock.clean;
  fi
}

######################################################################
#
# PID PUBLIC METHODS
#
######################################################################

# determine if we are using a pid file
function process.pid? {
  test -n "$process_pid";
}

# print the process id
function process.pid {
  echo -ne "$$";
}

# retrieve the path to the pid file for this process
function process.pid.name {
  local ext="pid";
  local pid=$$;
  # locks needn't include the pid in the name
  if process.lock?; then
    _result="${process_name}.${ext}";
  else
    _result="${process_name}.${pid}.${ext}";
  fi
}

# retrieve the path to the pid file for this process
function process.pid.file {
  process.tmp.dir;
  local process="$_result";
  process.pid.name;
  _result="${process}/${_result}";
}

# flag this program as using a PID file
function process.pid.use! { 
  if [ $# -eq 0 ]; then
    # switch on trapping exit so we can clean up
    # the pid file using the private handler
    process.signal.on __process.pid.clean exit;
    process.on exit;
  
    process_pid="on";
    __process.pid.write;
  else
    process_pid="";
    # clean the pid file immediately
    __process.pid.clean;
  fi
}

# TODO: add lock file support for lock processes

######################################################################
#
# PRIVATE METHODS
#
######################################################################

# responds to trap signals
function __process.trap {
  # exit code of last command
  local code="$1";
  
  # signal being processed
  local signal="$2";
  
  # echo "trap called with signal: $signal";
  
  # TODO: move to a callback method in process.daemon.start! ?
  if process.daemon?; then
    # switch off any daemon for these signals
    case "$signal" in
      exit ) process.daemon.stop! ;;
    esac
  fi
  
  # in test mode just output the signal name
  # if process.test?; then
  #   echo -ne "$signal";
  # else
  #   # TODO: tidy this output in non-debug mode
  #   echo "$FUNCNAME got signal : $signal";
  #   local data=( $( caller 1 ) );
  #   if [ ${#data[@]} -gt 0 ]; then
  #     echo "${data[@]}";
  #   fi
  #   echo "$FUNCNAME : $code : $1";
  # fi
  
  # trigger callbacks for the signal
  process.signal.trigger "$signal";
}

function __process.daemonize {
  local method="${1:-}";
  while $process_loop;
    do
      # invoke the daemon callback method
      if method.exists? "$method"; then
        "$method";
      # method may have been removed, stop!
      else
        process.daemon.stop!
      fi
  done
}

# write the pid to a file
function __process.pid.write {
  process.pid.file;
  local file="$_result";
  process.pid >| "$file" || quit 1 "could not write pid ($$) to file %s" "$file";
}

# remove the pid file
function __process.pid.clean {
  process.pid.file;
  local file="$_result";
  if test -f "$file"; then
    rm "$file" >| /dev/null 2>&1 || console warn "could not remove pid file %s" "$file";
  fi
}

# write the lock to a file
function __process.lock.write {
  process.lock.file;
  local file="$_result";
  process.pid >| "$file" || quit 1 "could not write lock file %s" "$file";
}

# remove the lock file
function __process.lock.clean {
  process.lock.file;
  local file="$_result";
  if test -f "$file"; then
    rm "$file" >| /dev/null 2>&1 || console warn "could not remove lock file %s" "$file";
  fi
}

# invoke initialize
process.initialize;
