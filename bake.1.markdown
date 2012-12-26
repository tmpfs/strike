bake(1) -- make for `bash`
=============================================

## SYNOPSIS

`bake` command [<var>options</var>...]<br>

## DESCRIPTION

**bake** is `make` for `bash` programs. The `bake` program does not define any tasks by default but some common shared tasks are available in the `modules/tasks` directory and can be included in a tasks file using:

	require 'tasks/clean';

## FILES

The bake(1) program looks for a `tasks` file in the current working directory and maps commands to the task methods found in the tasks file. A command is considered to be the first option passed to the `bake` executable, any other options specified on the command line are passed to the corresponding task method.

## BUGS

**bake** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**bake** is copyright (c) 2012 muji <http://xpm.io>

[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[FILES]: #FILES "FILES"
[BUGS]: #BUGS "BUGS"
[COPYRIGHT]: #COPYRIGHT "COPYRIGHT"


[bake(1)]: 	bake.1.html
[http(1)]: 	http.1.html
[rest(1)]: 	rest.1.html
[curl(1)]: 	http://man.cx/curl(1).html
[manpages(5)]: 	http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man5/manpages.5.html.html
[bake(1)]: bake.1.html
[http(1)]: http.1.html
[rest(1)]: rest.1.html
