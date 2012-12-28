bake(1) -- make for `bash`
=============================================

## SYNOPSIS

`bake` command [<var>options</var>...]<br>

## DESCRIPTION

**bake** is `make` for `bash` programs. The `bake` program does not define any tasks by default but some common tasks are available in the `modules/tasks` directory and can be included in a tasks file using `require`, for example:

	require 'tasks/clean';
	require 'tasks/list';

## FILES

The bake(1) program looks for a `tasks` file in the current working directory and maps commands to the task methods found in the tasks file. A command is considered to be the first option passed to the `bake` executable, any other options specified on the command line are passed to the corresponding task method.

## ENVIRONMENT

The following variables are available to each command method:

* `root`:
	The directory where the `tasks` file is located.

* `target`:
	A temporary `target` directory corresponding to `${root}/target`.
	
* `tasks`:
	The file system path to the tasks file, eg: `${root}/tasks`.
	
## EXIT CODES

* `1`:
	No tasks file available in the current working directory.
* `2`:
	No tasks command method available.
* `3`:
	The task method invocation exited with a non-zero exit code.

## BUGS

**bake** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**bake** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

strike(1), boilerplate(3), require(3), method(3), http(1), bake(1), rest(1)

[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[FILES]: #FILES "FILES"
[ENVIRONMENT]: #ENVIRONMENT "ENVIRONMENT"
[EXIT CODES]: #EXIT-CODES "EXIT CODES"
[BUGS]: #BUGS "BUGS"
[COPYRIGHT]: #COPYRIGHT "COPYRIGHT"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[strike(1)]: 	strike.1.html
[boilerplate(3)]: boilerplate.3.html
[require(3)]: 	require.3.html
[method(3)]: 	method.3.html
[http(1)]: 	http.1.html
[bake(1)]: 	bake.1.html
[rest(1)]: 	rest.1.html
[curl(1)]: 	http://man.cx/curl(1).html
[tee(1)]: 		http://man.cx/tee(1).html
[bake(1)]: bake.1.html
[http(1)]: http.1.html
[rest(1)]: rest.1.html
[strike(1)]: strike.1.html
