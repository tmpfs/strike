# generate the makefile
:tasks.bundle.makefile() {
	local makefile="${bundle_source}/${names[makefile]}";
	
	declare -A make_targets;
	make_targets[targets]="install";
	
	declare -A make_rules;
	make_rules[install]="./install.sh \$@";
	
	:tasks.bundle.makefile.header;
	:tasks.bundle.makefile.targets;
	:tasks.bundle.makefile.phony;
	
	# cat "$makefile";
	
	# %: force
	#              @$(MAKE) -f Makefile $@
	#      force: ;	
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
cat <<EOF >> "${makefile}"
.PHONY: ${make_targets[targets]}

EOF
}