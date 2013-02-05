# generate the makefile
:tasks.bundle.makefile() {
	local makefile="${bundle_source}/${names[makefile]}";
	
	# using a custom make file
	if [ -n "${sources[make]}" ]; then
		cp "${sources[make]}" "${makefile}" \
			|| :tasks.deploy.fail "could not copy make file %s" \
				"${sources[make]}";
		return 0;
	fi	
	
	declare -A make_targets;
	declare -A make_rules;
	
	local bundle_makefile="";
	local bundle_makefile_name="";
	local bundle_makefile_relative="";
	:tasks.bundle.makefile.exists?;
	local has_makefile=$?;
	local has_makefile_install_target=1;
	
	# write make file header
	:tasks.bundle.makefile.header;	
	
	# not a standalone bundle or no makefile bundled
	# so always proxy to the installation script
	if ! ${flags[bundle.standalone]} || [ $has_makefile -gt 0 ]; then
		:tasks.bundle.makefile.script.proxy;
		:tasks.bundle.makefile.targets;
	# standalone and a makefile is bundled
	# so let's see whether we proxy
	elif [ $has_makefile -eq 0 ]; then
		# make -qp | grep -v '^# ' | grep -v '^[[:space:]]' | grep --only-matching '^.*:' | grep 'install:';
		
			# echo "got custom makefile: $bundle_makefile"
			
			# determine if the makefile has a install target
			# executed in a subshell so the working directory
			# is not affected
			(
				cd "${bundle_contents_path}" \
					&& make -qp \
					| grep -v '^# ' \
					| grep -v '^[[:space:]]' \
					| grep --only-matching '^.*:' \
					| grep 'install:' > /dev/null 2>&1
			)
			has_makefile_install_target=$?;
			# no install target in bundled makefile
			# so we can proxy the install target to
			# the script and all other targets to the
			# bundled makefile using an include
			if [ $has_makefile_install_target -gt 0 ]; then
				# NOTE: the script proxy is done first so
				# NOTE: it becomes the default target and can
				# NOTE: be executed with just `make`
				:tasks.bundle.makefile.script.proxy;
				:tasks.bundle.makefile.targets;
				:tasks.bundle.makefile.proxy "${names[bundle.contents]}" "$bundle_makefile_name";
			# the bundled makefile has an install target
			# so we just proxy everything
			else
				:tasks.bundle.makefile.proxy "${names[bundle.contents]}" "$bundle_makefile_name";				
			fi
	fi
	
	:tasks.bundle.makefile.phony;
	
	# cat "$makefile";
}

# determine if a makefile name is recognised
:tasks.bundle.makefile.name.valid?() {
	local name="${1:-}";
	local word;
	for word in ${names[makefiles]}
		do
			if [ "$name" == "$word" ]; then
				return 0;
			fi
	done
	return 1;
}

# sets the makefile targets and rules to
# proxy to the installation script
:tasks.bundle.makefile.script.proxy() {
	make_targets[targets]="install";
	make_rules[install]="./${names[script]} \$@";
}

# write an include directive to the makefile
:tasks.bundle.makefile.proxy() {
cat <<EOF >> "${makefile}"
%: force
	@\$(MAKE) --directory $1 --file $2 \$@
force: ;

EOF
}

# determine if the package contents has a makefile
:tasks.bundle.makefile.exists?() {
	# FIXME: if the bundle is created on a case-insensitive
	# FIXME: platform but deployed to a case-sensitive platform
	# FIXME: the make file name will be incorrect in deployment
	local name;
	for name in ${names[makefiles]}
		do
			if [ -f "${bundle_contents_path}/${name}" ]; then
				bundle_makefile="${bundle_contents_path}/${name}";
				bundle_makefile_name="${name}";
				bundle_makefile_relative="${bundle_makefile#$bundle_source/}";
				return 0;
			fi
	done
	return 1;
}

:tasks.bundle.makefile.header() {
cat <<EOF >> "${makefile}"
# generated by task-deploy(7)
# do not edit this file manually
# use bake(1) with task-deploy(7)

EOF
}

:tasks.bundle.makefile.targets() {
	local word rule rules;
	for word in ${make_targets[targets]}
		do
			rules="${make_rules[$word]:-}";
			if [ -z "$rules" ]; then
				:tasks.deploy.fail "no rules for make target %s" "$word";
			fi
			
			# echo "got rules : $rules";
			local IFS=$'\n';
			rules=( ${rules} );
			unset IFS;
cat <<EOF >> "${makefile}"
${word}:
EOF
			for rule in "${rules[@]}"
				do
cat <<EOF >> "${makefile}"
	${rule}

EOF
			done
	done
}

:tasks.bundle.makefile.phony() {
	if [ -n "${make_targets[targets]:-}" ]; then
cat <<EOF >> "${makefile}"
.PHONY: ${make_targets[targets]}

EOF
	fi
}