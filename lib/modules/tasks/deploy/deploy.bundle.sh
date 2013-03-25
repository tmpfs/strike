# create the deployment bundle
bundle.create() {
  dly.out.info "creating bundle %s" "$bundle_archive";
  
  local bundle_size="${defaults[bundle.size]}";
  local bundle_contents_path="${bundle_source}/${names[bundle.contents]}";
  
  # must be done here to be written to info.json
  local shafile="${bundle_archive}.sha${setup[sha.algorithm]}";
  setup[sha.file]="${shafile}";
  
  # no point writing the sha data when not
  # generating a checksum
  if ! ${flags[sha]}; then
    unset setup[sha.algorithm];
    unset setup[sha.file];
  fi
  
  # always write the effective settings into the bundle
  bundle.settings.write!
  
  # add scripts to bundle
  bundle.scripts;
  
  # add package contents
  bundle.contents;
  
  bundle.exports.write!;
  
  # copy the descriptor
  bundle.descriptor.copy;
  
  # create the info.json file
  bundle.info.write!;
  
  bundle.configure.write!;
  
  # write the makefile wrapper
  makefile;
  
  # write all environment variables to a log file
  env | sort >| "${bundle_source}/${names[env.log]}";
  
  # create the bundle
  bundle.archive.create;
  
  # clean up after bundle creation
  rm -rfv "${bundle_source}" >> "${log}" 2>&1 \
    || dly.fail "could not clean bundle source %s" "$bundle_source";
    
  dly.out.info "created bundle %s (%s)" "$bundle_archive" "$bundle_size";
  dly.header;
}

# include any scripts in the bundle
bundle.scripts() {
  local global_scripts="${json_doc[bundle.scripts.length]:-0}";
  local profile_scripts="${json_doc[profiles.${profile}.bundle.scripts.length]:-0}";
  local total_scripts=$((global_scripts+profile_scripts));
  if [ $total_scripts -gt 0 ]; then
    dly.out.info "bundle %s script(s)" "$total_scripts";
    local scripts_path="${bundle_source}/${names[bundle.scripts]}";
    mkdir -p "${scripts_path}" \
      || dly.fail "could create bundle script directory %s" "$scripts_path";
      if [ $global_scripts -gt 0 ]; then
        bundle.scripts.group $global_scripts "bundle.scripts";
      fi
      if [ $profile_scripts -gt 0 ]; then
        bundle.scripts.group $profile_scripts "profiles.${profile}.bundle.scripts";
      fi
  fi
}

# adds bundle package contents
bundle.contents() {
  if ${flags[bundle.package.contents]}; then
    
    local cp_opts="-p";
    if ! ${flags[bundle.package.follow]}; then
      cp_opts="${cp_opts}R";
    fi
    
    mkdir -p "${bundle_contents_path}" \
      || dly.fail "could create bundle contents directory %s" \
        "$bundle_contents_path";    
    
    # TODO: make the source directory for packaging configurable
    local contents="${setup[wd]}";
    
    local exclude_file="${contents}/${names[bundle.ignore.file]}";
    local exclude_patterns=();
    
    # check if we need to obey a custom ignore file
    if [ -f "${exclude_file}" ]; then
      exclude_patterns=( $( < "${exclude_file}" ) );
      cp "${exclude_file}" "${bundle_source}";
    fi
    
    # be certain we are operating in the correct context
    cd "${contents}";
    local ignore_re="^((\.git/)+|(\.svn/)+)";
    dly.out.info "package contents %s" "${contents}";
    
    local file relative parent name path files symlink;
    if git.exists? && git.valid? "${contents}"; then
      files=( $( git ls-files ) );
      git ls-files \
        --others > "${bundle_source}/${names[bundle.ignore.git]}";
    else
      files=( $( find "${contents}" ) );
    fi
    
    local i length=${#files[@]:-0};
    for file in "${files[@]}"
      do
        fs.basename "${file}" "name";
        relative="${file#$contents/}";
        
        if bundle.contents.ignore?; then
          if ${flags[verbose]}; then
            dly.out.info "ignore %s" "${relative}";
          fi
          continue;
        fi

        if ${flags[verbose]}; then
          dly.out.info "add %s" "${relative}";
        fi
        
        # can't use cp --parents on BSD :(
        fs.dirname "${relative}" "parent";
        if [ "$parent" == "." ]; then
          parent="";
        fi
        path="${bundle_contents_path}";
        if [ -n "${parent}" ]; then
          path="${bundle_contents_path}/${parent}";
        fi
        
        # echo "file is: $file";
        # echo "parent is: $parent";
        # echo "name is: $name";
        # echo "destination is: $path";
        
        # create directories as needed
        # top-level file(a) don't need a parent created
        if [ ! -d "$path" ]; then
          mkdir -p "$path";
        fi
        
        if [ -f "${file}" ]; then
          # NOTE: we copy with -R even though it is a file
          # NOTE: to preserve symbolic links
          cp ${cp_opts} "${file}" "${path}/${name}";
        elif [ -L "${file}" ]; then
          symlink=$( readlink "$file" );
          # preserve symbolic links for directories
          if ! ${flags[bundle.package.follow]}; then
            cd "$path" && ln -s "$symlink" "$name";
            cd "${contents}";
          # TODO: copy over contents of symbolic link directory
          # TODO: when following symlinks
          fi
        fi
    done
    
    bundle.contents.include;
  fi
}

# generate configure, missing and install-sh when a configure.ac
# file is present but no configure file is available, requires
# that the *autoreconf* binary is available
bundle.contents.autoconf() {
  executable.validate --test autoreconf;
  if [ -f "${bundle_contents_path}/${names[autoconf.ac]}" ] \
    && [ ! -f "${bundle_contents_path}/${names[autoconf.configure]}" ] \
    && [ -n "${executables[autoreconf]:-}" ]; then
    dly.out.info "autoreconf -i";
    (
      cd "${bundle_contents_path}" \
        && "${executables[autoreconf]}" -i >> "${log}" 2>&1 \
        || dly.fail "error while running autoconf in %s" \
          "${bundle_contents_path}";
    )
    if [ -d "${bundle_contents_path}/${names[autoconf.cache]}" ]; then
      dly.out.info "rm -rfv %s" "${bundle_contents_path}/${names[autoconf.cache]}";
      rm -rfv "${bundle_contents_path}/${names[autoconf.cache]}" >> "${log}" 2>&1;
    fi
  fi
}

# always include files that are marked for inclusion
# regardless of any excludes
bundle.contents.include() {
  
  bundle.contents.autoconf;
  
  local i length file parent;
  length="${json_doc[bundle.files.include.length]:-0}";
  if ${flags[verbose]} && [ $length -gt 0 ]; then
    dly.out.info "include %s file(s)" "$length";
  fi
  
  for((i=0;i < $length;i++))
    do
      file="${json_doc[bundle.files.include.${i}.path]:-}";
      parent="${json_doc[bundle.files.include.${i}.dir]:-}";
      fs.basename "${file}" "name";
      relative="${file#$contents/}";
            
      if [ -n "$file" ]; then
        if ${flags[verbose]}; then
          dly.out.info "add %s" "${file}";
        fi
      else
        dly.fail "include file may not be empty";
      fi
      if [ -n "$parent" ]; then
        if [[ "$parent" =~ ^/ ]] || [[ "$parent" =~ ^\.\. ]]; then
          dly.fail "include directory must be relative";
        fi
      fi
      
      # considered to be an absolute path, copy into the
      # bundle source
      if [[ "$file" =~ ^/ ]] || [[ "$file" =~ ^\.\./ ]]; then
        echo "got absolute include reference ... ";
      fi
      
      echo "got file that must be included ... $file";      
  done
}

# write the variable exports file
# when exports have been declared
bundle.exports.write!() {
  local file="${bundle_source}/${names[exports]}";
  local i name value length="${json_doc[export.length]:-0}";
  if [ $length -gt 0 ]; then
    printf "" >| "${file}";
    dly.out.info "export %s variable(s)" "$length";
    for((i = 0;i < $length;i++))
      do
        name="${json_doc[export.$i.name]:-}";
        value="${json_doc[export.$i.value]:-}";
        if [ -z "$name" ]; then
          dly.fail "export variable name is missing";
        fi
        if [ -z "$value" ]; then
          dly.fail "export variable name is missing";
        fi
        if ${flags[verbose]}; then
          dly.out.info "export %s=%s" "$name" "$value";
        fi
        
        if [[ "$name" =~ $variable_name_sanitize_regexp ]]; then
          dly.fail "invalid export variable name %s, must match %s" \
            "$name" \
            "$variable_name_sanitize_regexp";
        fi
        
        printf "${name}=${value};\n" >> "${file}";
        printf "export ${name};\n" >> "${file}";
    done
  fi
}

# determine if a packaged file is being ignored
bundle.contents.ignore?() {
  if [[ "$relative" =~ $ignore_re ]]; then
    return 0;
  fi
  if ! ${flags[bundle.package.hidden]}; then
    if [[ "$name" =~ ^\. ]]; then
      return 0;
    fi
  fi
  if [ ${#exclude_patterns[@]} -gt 0 ]; then
    bundle.contents.xpmignore?;
    return $?;
  fi
  return 1;
}

# test for exclusion against .xpmignore patterns
bundle.contents.xpmignore?() {
  local ptn;
  for ptn in "${exclude_patterns[@]}"
    do
      [[ "$relative" =~ $ptn ]] && { return 0; }
      if [ $? -eq 2 ]; then
        dly.fail "invalid pattern %s" "$ptn";
      fi
  done
  return 1;
}

# 
bundle.scripts.group() {
  local i k file nm dir destination;
  local length="${1:-0}";
  local key_prefix="${2:-}";
  for((i = 0;i < $length;i++))
    do
      destination="${scripts_path}";
      k="${key_prefix}.${i}";
      file="${json_doc[${k}.file]:-}";
      dir="${json_doc[${k}.dir]:-}";
      
      echo "bundling with key: $k : $file";
      
      if [ -z "$file" ]; then
        dly.fail "script entry does not declare the %s field" "file";
      fi
      # resolve relative to the descriptor
      # otherwise treat as a relative or absolute path
      if [[ ! "$file" =~ ^(\.\.)?/ ]]; then
        file="${setup[wd]}/$file";
      fi
      if [ ! -f "$file" ]; then
        dly.fail "script %s does not exist" "${file}";
      fi
      if [ ! -x "$file" ]; then
        dly.fail "script %s is not executable" "${file}";
      fi
      fs.basename "${file}" "nm";
      if [ -f "${destination}/$nm" ]; then
        dly.fail "duplicate script %s, script names must be unique" "${nm}";
      fi
      
      # got a custom directory structure for the script
      if [ -n "${dir}" ]; then
        if [[ "$dir" =~ ^[./] ]]; then
          dly.fail "invalid script directory %s, may not begin with . or /" "${dir}";
        fi
        # echo "ADDING TO CUSTOM DIRECTORY (after): $dir";
        dly.out.info "create script directory %s" "$dir";
        destination="${destination}/${dir}";
        mkdir -p "${destination}" \
          || dly.fail "could not creat scripts directory %s" "${destination}";
      fi
      
      cp "$file" "${destination}" \
        || dly.fail "could not copy script %s" "${file}";
  done
}

# copy the descriptor to the bundle source directory
bundle.descriptor.copy() {
  cp "${descriptor}" "${bundle_source}/${names[descriptor.output]}" \
    || dly.fail "could not copy bundle descriptor %s" "$bundle_path";
}

# create the bundle archive
bundle.archive.create() {
  {
    cd "$bundle_output" \
      && tar -cf "$bundle_archive" "$bundle_name";
  } || dly.fail "failed to create bundle %s" "$bundle_path";
  
  
  if ${flags[sha]}; then    
    checksum.sha "${setup[sha.algorithm]}" "$bundle_archive" >| "${shafile}" \
      || dly.fail "could not generate checksum for %s" "${bundle_archive}";
    dly.out.info "sha file %s" "${shafile}";
  fi
  
  local size=( $( du -h "${bundle_archive}" ) );
  bundle_size="${size[0]}";
  
  if ${flags[bundle.inspect]}; then
    local inspect_opts="-t";
    if ${flags[verbose]}; then
      inspect_opts="${inspect_opts}v";
    fi
    inspect_opts="${inspect_opts}f";
    tar $inspect_opts "${bundle_archive}";
  fi
  
  # revert to the main working directory
  cd "${setup[wd]}";
}

# write the info.json file
bundle.info.write!() {
  # TODO: when processing multiple profiles, we only need to generate this info once!!!
  
  local info="${bundle_source}/info.json";
  local k v;
    
  # also expose the flags
  for k in "${!flags[@]}"
    do
      v="${flags[$k]}";
      setup["flags.$k"]="$v";
  done
  
  json.stringify --pretty 2 <<< "setup" > "${info}";
}

# write the deploy settings for the profile to the bundle
bundle.settings.write!() {
  # TODO: fix json.stringify memory leak
  # TODO: probably due to the string concatenation
  
  if ${flags[verbose]}; then
    dly.out.info "write %s" "${settings}";
  fi
  
  # echo "keys are: ${!json_dump[@]}"; exit 0;
  
  # echo "before write json";
  json.stringify --pretty 2 <<< "json_dump" > "${settings}";
}

# creates a package.json for an *npm* installation type
bundle.npm.package.write!() {
  local npm_package_file="${bundle_source}/package.json";
  dly.out.info "npm name %s" "$npm_package_name";
  dly.out.info "npm version %s" "$npm_package_version";
  dly.out.info "npm package %s" "$npm_package_file";
  
  # create the npm package descriptor file
  touch ${npm_package_file} \
    || dly.fail "could not create %s" "$npm_package_file";
      
# write out the package descriptor into the bundle source directory
cat <<NPMPKG >> ${npm_package_file}
{
  "name": "${project_name}-${profile}-npm-deploy",
  "version": "0.0.1", 
  "private": "true",
  "dependencies": {
    "$npm_package_name": "${url}"
  }
}
NPMPKG
}

# write the configure script to the
# root of the bundle
bundle.configure.write!() {
  local configure="${bundle_source}/${names[autoconf.configure]}";
cat <<EOF >> ${configure}
#!/bin/sh

set -e;
set -u;

if test -d ./${names[bundle.contents]} \\
  && test -f ./${names[bundle.contents]}/${names[autoconf.configure]}; then
  printf "${names[autoconf.configure]}: ";
  printf "./${names[bundle.contents]}/${names[autoconf.configure]}\n";
  (
    cd ./${names[bundle.contents]} \\
      && ./${names[autoconf.configure]} \$@
  ) || exit 1;
  echo "${names[autoconf.configure]}: make && make install";
  exit $?;
else
  echo "${names[autoconf.configure]}: nothing to be done for $deploy_name";
  echo "${names[autoconf.configure]}: make && make install";
  exit 0;
fi
EOF

  chmod +x "${configure}" \
    || dly.fail "could not set permissions on %s" "${configure}";
}

# perform the bundle installation
bundle.install!() {
  
  # local deployment
  if ${flags[deploy.local]}; then
    
    # if we have make(1) we run: ./configure && make && make install
    # otherwise the install.sh script is run directly
    executable.validate --test make;    
    
    dly.out.info "local install %s" "${bundle_archive}";
    # copy packaged bundle to staging
    cp "${bundle_path}" "${staging}" \
      || dly.fail "could not copy bundle %s" "${bundle_path}";
    cd "${staging}" && tar -xf "${bundle_archive}" \
      || dly.fail "could not extract bundle %s" "${staging}/${bundle_archive}";
    
    # script_name
    cd "${bundle_name}" \
      || dly.fail "could not enter %s" "${staging}/${bundle_name}";
      
    if [ -f "${names[exports]}" ]; then
      . "${names[exports]}";
    fi
      
    #  && dly.complete
    if [ -n "${executables[make]}" ]; then
      ./configure && make -s && make -s install || dly.fail;
    else
      #  && dly.complete
      # run the script directly
      if ! ${flags[logging]}; then
        "./${script_name}" || dly.fail;
      else
        "./${script_name}" >> "${log}" 2>&1 || dly.fail;
      fi
    fi
  # remote deployment
  else
    executable.validate scp ssh;
    # TODO: implement
    echo "start remote deployment ... ";
  fi
  
  # local test_staging='test -d '${staging}'; echo $?;';
  # local mk_staging='mkdir -p '${staging}'';
  # 
  # # test if the staging directory exists
  # dly.out.info "${executables[ssh]} %s %s" \
  #   "${host}" "${test_staging}";
  # local exists=0;
  # if ! ${flags[noop]}; then
  #   exists=$( "${executables[ssh]}" "${host}" ""${test_staging}"" );
  # fi
  # 
  # # create remote staging directory if it does not exist
  # if [ $exists -gt 0 ]; then
  #   dly.out.info "${executables[ssh]} %s %s" \
  #     "${host}" "${mk_staging}";
  #   if ! ${flags[noop]}; then
  #     ( "${executables[ssh]}" "${host}" ""${mk_staging}"" ) \
  #       || dly.fail \
  #       "could not create remote staging directory %s" \
  #       "${staging}";
  #   fi
  # fi
  # 
  # local remote="${host}:${staging}/${script_name}";
  # dly.out.info "scp -p %s %s" \
  #   "${script}" "${remote}";
  # if ! ${flags[noop]}; then
  #   echo "SCP SCRIPT";
  # fi  
}