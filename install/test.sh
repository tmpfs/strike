#!/usr/bin/env bash --posix

test_install() {
	# `tcsh` and `csh` do not work due to core differences
	# between `setenv` and `export`
	local shells=( sh dash ksh bash zsh );
	local sh path;
	for sh in ${shells[@]}
		do
			path=$( command -v "$sh" );
			if test -n "$path"; then
				printf "\n";
				printf "testing shell $sh ($path)\n\n";
				"$path" "./install.sh" --noop;
			else
				printf "no shell $sh available\n";
			fi
	done
}

test_install;