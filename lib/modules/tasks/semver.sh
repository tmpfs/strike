require.once semver;
require.once json;

taskinfo semver "Semantic versioning support";
tasks.semver() {
  # gather file information
  declare -A files;
  __semver.package.file;
  files[package]="$_result";
  __semver.version.file;
  files[version]="$_result";  
  __semver.file;
  files[semver]="$_result";
  
  # store of semver strings
  declare -A versions;
  versions[package]="";
  versions[version]="";
  versions[semver]="";

  # parse semver strings where possible 
  if __semver.package.file.exists?; then
    __semver.package.parse;
    versions[package]="$_result";
  fi
  if __semver.version.file.exists?; then
    __semver.version.parse;
    versions[version]="$_result";
  fi
  if __semver.file.exists?; then
    __semver.parse;
    versions[semver]="$_result";
  fi
  
  # the first available version string
  __semver.version;
  local version="$_result";
  
  if [ "${1:-}" != "sync" ]; then
    # test if everything is in sync
    $( sv.tasks.semver.sync > /dev/null 2>&1 );
    local ok=$?;
    if [ $ok -gt 0 ]; then
      # write.* commands would bring semvers back in sync
      if [ "${1:-}" != "write" ]; then
        # quit on out of sync semver files
        __semver.sync.quit;
      fi
    fi
  fi
  
  # do command procesing via delegation
  if [ $# -gt 0 ]; then
    local method="sv.${FUNCNAME}.${1}";
    if ! method.exists? "$method"; then
      console quit 1 "invalid semver command %s" "$1";
    else
      delegate "sv.${FUNCNAME}" "$1" ${@:2};
    fi
  else
    # no options specified init files
    sv.tasks.semver.init;
  fi
}

# tests if a semver is valid
function sv.tasks.semver.test {
  local semver;
  if [ $# -eq 0 ]; then
    console quit 1 "no semver specified to test";
  else
    if semver.valid? "$1"; then
      console info "semver %s is ok" "$1";
    else
      __semver.invalid.warn "$1";
      __semver.invalid.quit "$1";
    fi
  fi
}

# read semver information
function sv.tasks.semver.read {
  __semver.print;
}

# write raw semver information
function sv.tasks.semver.write {
  local semver="${1:-}";
  
  if [ $# -eq 0 ]; then
    quit 1 "no semver specified";
  elif ! semver.valid? "$semver"; then
    quit 1 "semver %s is invalid" "$semver";
  fi  
  
  __semver.write!;
}

# determines whether semvers in all files are in sync
function sv.tasks.semver.sync {
  if [ $# -eq 0 ]; then
    local valid=0;
    local keys=( package version semver );
    declare -A invalid;
    local key subkey;
    for key in ${keys[@]}
      do
        if [ -n "${versions[$key]}" ] && [ -f "${files[$key]}" ]; then
          for subkey in ${keys[@]}
            do
              # don't compare to self
              if [ "$key" != "$subkey" ]; then
                if [ "${versions[$key]}" != "${versions[$subkey]}" ]; then
                  console warn "%s != %s" "${versions[$key]}" "${versions[$subkey]}";
                  console warn "%s != %s" "${files[$key]}" "${files[$subkey]}";
                  valid=1;
                fi
              fi
          done
        fi
    done
    
    if [ $valid -eq 0 ]; then
      console.ok "semver %s %s" "$version";
    else
      __semver.sync.quit;
    fi
    
    return $valid;
  else
    # TODO: allow specifc sync identifier commands
    echo "sync on file type id $1";
  fi
}

# init semver files
function sv.tasks.semver.init { 
  if ! __semver.version.file.exists?; then
    console info "creating %s" "${files[version]}";
    # create the version file
    __semver.version.write! "$version";
    versions[version]="$version";
  fi
  
  if ! __semver.file.exists?; then
    console info "creating %s" "${files[semver]}";
    # create the semver.json file
    __semver.file.write! "$version";
    versions[semver]="$version";
  fi
  
  # print summary
  __semver.print;
}

# increment or decrement a major version
function sv.tasks.semver.major {
  # TODO: add --force flag to prevent prompt for programmatic control
  declare sv_prefix="bump";
  # decrement
  if [ "${1:-}" == "-" ]; then
    semver.major! - "$version";
    sv_prefix="revert";
  # increment
  else
    semver.major! "$version";
  fi
  local newversion="$_result";
  declare sv_msg="$sv_prefix major version";
  
  # TODO: test if version == newversion for decrement, nothing to be done
  # TODO: add rollback warning on decrement
  
  # release process from 0 > 1 major version
  if [[ "$version" =~ ^0 ]] && [[ "$newversion" =~ ^1 ]]; then
    __semver.release; 
  # simple bump
  else
    __semver.confirm;
  fi
}

# increment or decrement a minor version
function sv.tasks.semver.minor {
  # TODO: add --force flag to prevent prompt for programmatic control
  
  declare sv_prefix="bump";
  # decrement
  if [ "${1:-}" == "-" ]; then
    semver.minor! - "$version";
    sv_prefix="revert";   
  # increment
  else
    semver.minor! "$version";
  fi
  local newversion="$_result";
  declare sv_msg="$sv_prefix minor version";  
  
  # TODO: test if version == newversion for decrement, nothing to be done 
  # TODO: add rollback warning on decrement 
  
  # simple confirmation for minor release changes
  __semver.confirm;
}

# increment or decrement a patch version
function sv.tasks.semver.patch {
  # TODO: add --force flag to prevent prompt for programmatic control
  
  declare sv_prefix="bump";
  # decrement
  if [ "${1:-}" == "-" ]; then
    semver.patch! - "$version";
    sv_prefix="revert";   
  # increment
  else
    semver.patch! "$version";
  fi
  local newversion="$_result";
  declare sv_msg="$sv_prefix patch version";
  
  # TODO: test if version == newversion for decrement, nothing to be done 
  # TODO: add rollback warning on decrement 
  
  # simple confirmation for major release changes
  __semver.confirm;
}

######################################################################
#
# PRIVATE METHODS
#
######################################################################

# INTERACTIVE METHODS

function __semver.change.confirm {
  local callback="$1";
  local prefix="${2:-}";
  if [ -n "$prefix" ]; then
    prefix="${prefix} "
  fi
  
  accepted() {
    $callback;
  }
  
  rejected() {
    console quit 1 "aborted";
  }
  
  console prompt "${prefix}%s > %s, are you sure? (y/n)" "$version" "$newversion";
  prompt confirm --accepted=accepted --rejected=rejected;
}

# semver change confirmation
function __semver.confirm {
  ok() {
    console info "$sv_msg %s" "$newversion";
    sv.tasks.semver.write "$newversion";
  }
  __semver.change.confirm "ok" "$sv_msg"; 
}

# RELEASE MANAGEMENT

# go through the release process
function __semver.release {
  
  # TODO : skip straight to release process it not a tty
  
  __semver.release.warn;
  __semver.release.confirm "__semver.release.confirmed";
}

function __semver.release.warn {
  #string.repeat "+" 80;
  #local header="$_result";
  
  local opts="--text=magenta";

  console header $opts; 
  console title $opts "You are about to go from major version %s to major version %s" "0" "1";
  console title $opts "creating a public version of your software.";
  console title $opts "";
  console title $opts "This means you are about to create a %s for your software" "PUBLIC API";
  console title $opts "and you should be certain that you wish to proceed.";
  console title $opts ""; 
  console title $opts "You should perform the following actions before creating version %s:" "1";
  console title $opts ""; 
  console title $opts " * Run unit tests using %s or %s" "npm test" "bake test";
  console title $opts " * Check for %s and %s tags" "BUG" "FIXME";
  console title $opts " * Generate documentation using %s" "bake doc man build";
  console title $opts " * Publish documentation using %s" "bake doc.pages.push";
  console header $opts;
}

# initial release confirmation
function __semver.release.confirm {
  local callback="$1";
  
  accepted() {
    $callback;
  }
  
  rejected() {
    console quit 1 "aborted";   
  }
  
  console prompt "are you sure you want to release to %s? (y/n)" "$newversion";
  prompt confirm --accepted=accepted --rejected=rejected;
}

# accepted the release process
function __semver.release.confirmed {
  local callback="$1";
  
  next() {
    __semver.release.preprocess;
  }
  
  accepted() {
    # TODO: update new version
    # TODO: ensure any release and build properties are included
    newversion="1.0.0";
    console info "set release to %s" "$newversion";
    next;
    return 0;
  }
  
  rejected() {
    # move on to next step without modifying
    # the new version
    console info "using %s" "$newversion";
    next;
  }
  
  # echo "$FUNCNAME : check release version $newversion";
  
  # validate release version is 1.0.0 or prompt to switch to 1.0.0 version
  semver.callback() {
    if [ ${semver[major]} -eq 1 ] && [ ${semver[minor]} -eq 0 ] && [ ${semver[patch]} -eq 0 ]; then
      console print "release version is already at 1.0.0";
      next;
    else
      console prompt "would you prefer to use %s instead of %s? (y/n)" "1.0.0" "$newversion";
      prompt confirm --accepted=accepted --rejected=rejected;
    fi
  }
  semver.parse "$newversion" "semver.callback";
}

# performs release preporcessing actions
function __semver.release.preprocess {
  __semver.release.preprocess.test \
    && __semver.release.preprocess.todo;
}

function __semver.release.preprocess.test {
  local testlog="${target}/release.test.log";
  # use: npm test
  if __semver.package.file.exists?; then
    console info "%s > %s" "npm test" "$testlog";
    # TODO: integrate with pushd / popd
    # pushd "$PWD";
    cd "${root}" && npm test > "$testlog" || quit 1 "unit tests failed";
    # popd;
    return $?;
  # use: bake test
  else
    #TODO: look for bake test task!?
    echo -ne '';
  fi
  return 0;
}

function __semver.release.preprocess.todo {
  local scanlog="${target}/release.todo.log";
  console info "scan %s %s > %s" "BUG" "FIXME" "$scanlog";
  
  require.once "tasks/todo";
  $( tasks.todo scan --bug --fixme > "$scanlog" 2>&1 );
  local tags=$?;
  if [ $tags -ne 0 ]; then
    quit 1 "found %s %s and/or %s tags, cannot release" "$tags" "BUG" "FIXME";
  fi
}

# finds the first available semver string
function __semver.version {
  _result="";
  if [ -n "${versions[package]}" ]; then
    _result="${versions[package]}";
  elif [ -n "${versions[version]}" ]; then
    _result="${versions[version]}";
  elif [ -n "${versions[semver]}" ]; then
    _result="${versions[semver]}";
  fi
}

# prints all available version information
function __semver.print {
  if [ ! -f "${files[semver]}" ] && [ ! -f "${files[package]}" ] && [ ! -f "${files[version]}" ]; then
    __semver.files.missing.quit;
  else
    # package.json
    if [ -f "${files[package]}" ] && [ -r "${files[package]}" ]; then
      if semver.valid? "${versions[package]}"; then
        __semver.file.semver.info "${versions[package]}" "${files[package]}";
      else
        __semver.invalid.warn "${versions[package]}";
      fi
    else
      __semver.file.missing.warn "${files[package]}";
    fi
    
    # version
    if [ -f "${files[version]}" ] && [ -r "${files[version]}" ]; then
      __semver.file.semver.info "${versions[version]}" "${files[version]}";
    else
      __semver.file.missing.warn "${files[version]}";
    fi
    
    # semver.json
    if [ -f "${files[semver]}" ] && [ -r "${files[semver]}" ]; then
      __semver.file.semver.info "${versions[semver]}" "${files[semver]}";
    else
      __semver.file.missing.warn "${files[semver]}";
    fi
    
    # print useful information if some files are missing
    __semver.missing.files.info;
  fi
}

# PARSE METHODS

# parse a version string from the `package.json` file
function __semver.package.parse {
  json.parse < "${files[package]}";
  _result="${json_doc[version]:-}";
  # clean the parsed json data, we're done
  json.clean;
}

# parse a version string from the `version` file
function __semver.version.parse {
  _result=`cat "${files[version]}"`;
}

# parse a version string from the `semver.json` file
function __semver.parse {
  declare -A semver;
  json.parse < "${files[semver]}";
  semver[major]="${json_doc[semver.major]}";
  semver[minor]="${json_doc[semver.minor]}";
  semver[patch]="${json_doc[semver.patch]}";
  semver[release]="${json_doc[semver.release]:-}";
  semver[build]="${json_doc[semver.build]:-}";
  semver.stringify;
}

# FILE WRITE METHODS

# write a semver to all available files
function __semver.write! {
  local semver="${1:-$semver}";
  console info "write semver %s" "$semver";
  # only write to a package if it exists
  if __semver.package.file.exists?; then
    __semver.package.write! "$semver";
    versions[package]="$semver";
  fi
  
  # always write to `version` and `semver.json`
  __semver.version.write! "$semver";
  versions[version]="$semver";
  
  __semver.file.write! "$semver";
  versions[semver]="$semver";

  __semver.print;

  #
  if method.exists? semver.git; then
    semver.git "$semver" "$version";
  fi
}

# write a semver to `package.json`
function __semver.package.write! {
  local version="${1:-}";
  local regexp="(\"version\"[   ]*:[  ]*\")[^\"]+(\")";
  local replace="\1$version\2";
  
  # 0.1.1
  
  executable.validate --test sed;
  
  # TODO: validate sed executable has -E flag
  # TODO: fallback to json parsing if sed -E is unavailable 
  
  if [ -n "${executables[sed]}" ]; then
    # do this with `sed` for the moment
    # as parsing the json and re-writing will
    # change formatting (key order, whitespace etc.)
    # which we want to avoid
    # it's quite possible that the -E flag will break on
    # other platforms
    { ${executables[sed]} -E -i.bak "s/$regexp/$replace/" "${files[package]}" \
      && mv "package.json.bak" "${target}"; } \
      || __semver.file.write.quit "${files[package]}";
    return $?;
  fi
  
  # assume failure
  return 1;
}

# writes a semver to `version`
function __semver.version.write! {
  local version="${1:-}";
  echo -ne "$version" >| "${files[version]}" || __semver.file.write.quit "${files[version]}";
  return 0;
}

# writes a semver to `semver.json`
function __semver.file.write! {
  local version="${1:-$version:-}";
  
  # TODO: read before write if file exists  
  
  declare -A semverdoc;
  # got a valid semver string
  semverdoc[generator]="task-semver(7), do not edit this file manually use bake(1) with task-semver(7)";
  semverdoc[semver.version]="$version";
  semver.callback() {
    local keys=( ${!semver[@]} );
    local key val;
    for key in ${keys[@]}
      do
        val="${semver[$key]}";
        semverdoc["semver.${key}"]="$val";
    done
    
    # encoded the semver data to a JSON document
    json.stringify <<< "semverdoc" >| "${files[semver]}" || __semver.file.write.quit "${files[semver]}";
  }
  
  # parse the current semver
  semver.parse "$version" "semver.callback";
  
  method.remove "semver.callback";
  return 0;
}

# FILE PATH METHODS

# path to the package descriptor
function __semver.package.file {
  _result="${root}/package.json";
}

# path to version file
function __semver.version.file {
  _result="${root}/version";
}

# path to the semver file
function __semver.file {
  _result="${root}/semver.json";
}

# FILE TEST METHODS

# determine if a package descriptor exists
function __semver.package.file.exists? {
  test -f "${files[package]}";
}

# determine if a version file exists
function __semver.version.file.exists? {
  test -f "${files[version]}";
}

# determine if a semver json file exists
function __semver.file.exists? {
  test -f "${files[semver]}";
}

######################################################################
#
# PRIVATE OUTPUT UTILITY METHODS
#
######################################################################

function __semver.sync.quit {
  console error "semver %s to sync semvers" "sync package|version|semver";
  console quit 1 "semver %s %s" "$version"; 
}

function __semver.missing.files.info {
  if [ -f "${files[package]}" ] && [ ! -f "${files[semver]}" ] && [ ! -f "${files[version]}" ]; then
    console info "run %s to create files" "bake semver";
  fi
}

function __semver.file.semver.info {
  console info "%s < %s" "$1" "$2";
}

function __semver.file.write.quit {
  console quit 1 "could not write %s" "$1";
}

function __semver.invalid.warn {
  console warn "semver %s is not ok" "$1";
}

function __semver.invalid.quit {
  console quit 1 "invalid semver %s" "$1";
}

function __semver.file.exists.info {
  console.ok "%s" "$1";
}

function __semver.files.missing.quit {
  console quit 1 "no semver files available"; 
}

function __semver.file.missing.warn {
  console notok "%s" "$1";
}
