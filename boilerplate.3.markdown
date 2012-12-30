boilerplate(3) -- boilerplate for strike(1)
=============================================

## SYNOPSIS

Before using the strike(1) modules and functions you need to include some boilerplate code which is responsible for determining the filesystem path to the executable (including resolving symbolic links).

## CODE

If you have installed the `strike` library as a node module and your executable is in a `bin` directory (sibling of the `node_modules` directory) the boilerplate would look like:

	declare -gx exedir;
	function boilerplate {
		local abspath=$(cd ${BASH_SOURCE[0]%/*} && echo $PWD/${0##*/});
		if [ -L "$abspath" ]; then
			abspath=`readlink $abspath`;
		fi
		if [[ "$abspath" =~ ^\./ ]]; then
			abspath="${PWD}/${abspath}";
		fi		
		exedir=`dirname "$abspath"`;
		local libdir="$exedir/../node_modules/strike/lib";
		source "$libdir/shared" "$@";
	}
	boilerplate "$@";

## COPYRIGHT

**boilerplate** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

strike(1)

[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[CODE]: #CODE "CODE"
[COPYRIGHT]: #COPYRIGHT "COPYRIGHT"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[strike(1)]: strike.1.html
[boilerplate(3)]: boilerplate.3.html
[require(3)]: require.3.html
[method(3)]: method.3.html
[http(3)]: http.3.html
[bake(1)]: bake.1.html
[rest(1)]: rest.1.html
[git(1)]: http://git-scm.com/
[bash(1)]: http://man.cx/bash(1)
[curl(1)]: http://man.cx/curl(1)
[tee(1)]: http://man.cx/tee(1)
[ronn(1)]: https://github.com/rtomayko/ronn
[github(7)]: http://github.com/
[json-sh(1)]: https://github.com/dominictarr/JSON.sh
[npm(1)]: http://npmjs.org
[delegate(3)]: delegate.3.html
[executable(3)]: executable.3.html
[globals-api(3)]: globals-api.3.html
[help(7)]: help.7.html
[strike-credits(7)]: strike-credits.7.html
[strike-tree(7)]: strike-tree.7.html
[strike(7)]: strike.7.html
[task-assert(7)]: task-assert.7.html
[task-clean(7)]: task-clean.7.html
[task-doc(7)]: task-doc.7.html
[task-list(7)]: task-list.7.html
