bake(1) -- make for bash
=============================================

## SYNOPSIS

`bake` command [<var>options</var>...]<br>

## DESCRIPTION

**bake** is `make` for bash programs. It provides an extensible system for managing project tasks using modular code.
	
# BUILTIN TASKS

All bake(1) projects have the following tasks built in task-test(7), task-clean(7), task-list(7), task-doc(7) and task-semver(7).

# REQUIRE TASKS

The convention is that task methods are not declared in tasks(7) but are placed in modules and then included using require(3). So to include the task-todo(7) functionality into your project all you need to do is require(3) it:

	require 'tasks/todo';

## FILES

The bake(1) program looks for a tasks(7) file in the current working directory. If no tasks(7) file is found in the current working directory then bake(1) will walk all parent directories looking for a tasks(7) file.

It maps commands (the first option passed to bake(1)) to task method(s) declared by the tasks file. A command is considered to be the first option passed to the `bake` executable, any other options specified on the command line are passed to the corresponding task method.

## ENVIRONMENT

The following variables are available to each command method:

* `root`:
	The directory where the `tasks` file is located.

* `target`:
	A temporary `target` directory corresponding to `${root}/target`.
	
* `tasks`:
	The file system path to the tasks file, eg: `${root}/tasks`.
	
## EXIT CODES

A >0 exit code is used when no task(7) file could be located or no command is available, otherwise the exit code is deferred to the task being executed.

* `1`:
	No task(7) file available in the current working directory (or any parent directories).
* `2`:
	No task command available.
* `>0`:
	The task command invocation returned a non-zero exit code but did not explicitly call `exit`.
	
It is recommended that task command implementations explicitly exit the program using the `quit` and `success` commands declared by console(3).

## BUGS

**bake** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**bake** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

task-test(7), task-doc(7), task-clean(7), task-list(7)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[FILES]: #FILES "FILES"
[ENVIRONMENT]: #ENVIRONMENT "ENVIRONMENT"
[EXIT CODES]: #EXIT-CODES "EXIT CODES"
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
[echo(1)]: http://man.cx/echo(1)
[find(1)]: http://man.cx/find(1)
[tee(1)]: http://man.cx/tee(1)
[ronn(1)]: https://github.com/rtomayko/ronn
[github(7)]: http://github.com/
[json-sh(1)]: https://github.com/dominictarr/JSON.sh
[npm(1)]: http://npmjs.org
[ruby(3)]: http://www.ruby-lang.org/
[rake(1)]: http://rake.rubyforge.org/
[semver(7)]: http://semver.org/
[sed(1)]: http://man.cx/sed(1)
[ant(1)]: http://ant.apache.org/
[printf(1)]: http://man.cx/printf(1)
[source(1)]: http://man.cx/source(1)
[array(3)]: array.3.html
[console(3)]: console.3.html
[delegate(3)]: delegate.3.html
[executable(3)]: executable.3.html
[git(3)]: git.3.html
[globals-api(3)]: globals-api.3.html
[help(7)]: help.7.html
[json(3)]: json.3.html
[semver(3)]: semver.3.html
[strike-credits(7)]: strike-credits.7.html
[strike-tree(7)]: strike-tree.7.html
[strike(7)]: strike.7.html
[task-ant(7)]: task-ant.7.html
[task-clean(7)]: task-clean.7.html
[task-doc(7)]: task-doc.7.html
[task-list(7)]: task-list.7.html
[task-rake(7)]: task-rake.7.html
[task-semver(7)]: task-semver.7.html
[task-test(7)]: task-test.7.html
[task-todo(7)]: task-todo.7.html
