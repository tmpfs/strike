executable(3) -- executable module
=============================================

## SYNOPSIS

Module methods for system executables.

## DESCRIPTION

Enables validation and referencing of executables in `$PATH`.

## REQUIRE

In your tasks(7) file `require` the `executable` module using:

	require 'executable';

## USAGE

Once the module is available you can then validate a list of executables:

	executable validate ronn git;
	
If any of the listed executables are not available on the system the program will exit with a non-zero exit code. If executable validation succeeds the executable paths are available in the global `executables` associative array and can be accessed anywhere in the program, for example:

	local git="${executables[git]}";

## BUGS

**executable** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**executable** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

require(3)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[REQUIRE]: #REQUIRE "REQUIRE"
[USAGE]: #USAGE "USAGE"
[BUGS]: #BUGS "BUGS"
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
