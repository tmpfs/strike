bake(1) -- make for bash
=============================================

## SYNOPSIS

Delegates to task commands after setting a context.

## DESCRIPTION

**bake** is `make` for bash programs. It provides an extensible system for managing project tasks using modular code.

## USAGE

	bake [task] [options...]

## OPTIONS

The following options are parsed by bake(1), all other options are passed on to the task command.

* `-v | --verbose`:

Set verbose mode for the task execution.

* `--color=always|never|auto`:

Define how ANSI escape sequences are generated, default is *auto*, see sprintf(3).

* `--version`:

Print the program version and exit.
	
## BUILTIN TASKS

All bake(1) projects have the following tasks built in:

* ls
* clean

These commands will print more information if the `-v | --verbose` option is specified.

## REQUIRE TASKS

The convention is that task commands are not declared in tasks(7) but are placed in modules and then included using require(3). So to include the semantic versioning functionality into your project all you need to do is require(3) it:

	require tasks/semver;

## FILES

The bake(1) program looks for a tasks(7) file in the current working directory. If no tasks(7) file is found in the current working directory then bake(1) will walk all parent directories looking for a tasks(7) file.

It maps commands (the first option passed to bake(1)) to a task command either builtin or declared (or required) by the tasks file. A task is considered to be the first option passed to the `bake` executable, any other options specified on the command line are passed to the corresponding task command.

## VARIABLES

The following variables are available to each task command:

* `root`:

The directory where the `tasks` file is located.

* `project_name`:

The name of the project as determined by the name of the `${root}` directory.

* `project`:

This is the root of the project. For most projects this will be equivalent to `${root}` but is useful for multi-module projects where `${root}` points to the directory for the module and `${project}` is the root of the project.

* `project_version`:

The project version number, if no version information is available the value *0.0.0* is used.

* `target`:

A staging directory corresponding to `${root}/target`.

* `tasks`:

The file system path to the tasks file, eg: `${root}/tasks`.

* `tasks_file_name`:

The name of the `tasks` file, if `bake_file_name` has been set this will equal that value, otherwise the default *tasks* is used.

* `verbose`:

Set to true if the `-v | --verbose` option was specified otherwise false.

## ENVIRONMENT

* `bake_file_name`:

Determines the name of the file that bake(1) looks for to load task command methods from, default is *tasks*.

* `bake_root`:

Allows setting of the root directory for an execution. This should be used with caution and is only made available for allowing file write during an execution of `make distcheck`.

## EXIT CODES

A >0 exit code is used when no task(7) file could be located or no command is available, otherwise the exit code is deferred to the task being executed.

* `1`:

No task(7) file available in the current working directory (or any parent directories).

* `2`:

No task command available.

* `>0`:

The task command invocation returned a non-zero exit code but did not explicitly call `exit`.

It is recommended that task command implementations explicitly exit the program using the `quit` and `success` sub-commands declared by console(3).

## BUGS

**bake** is written in bash and depends upon `bash` >= 4.2.

## COPYRIGHT

**bake** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

sprintf(3), console(3), task-test(7), task-doc(7), task-clean(7), task-ls(7), task-semver(7)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[USAGE]: #USAGE "USAGE"
[OPTIONS]: #OPTIONS "OPTIONS"
[BUILTIN TASKS]: #BUILTIN-TASKS "BUILTIN TASKS"
[REQUIRE TASKS]: #REQUIRE-TASKS "REQUIRE TASKS"
[FILES]: #FILES "FILES"
[VARIABLES]: #VARIABLES "VARIABLES"
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
[bash(1)]: http://man.cx/bash(1)
[curl(1)]: http://man.cx/curl(1)
[echo(1)]: http://man.cx/echo(1)
[find(1)]: http://man.cx/find(1)
[tee(1)]: http://man.cx/tee(1)
[sed(1)]: http://man.cx/sed(1)
[printf(1)]: http://man.cx/printf(1)
[source(1)]: http://man.cx/source(1)
[dirname(1)]: http://man.cx/dirname(1)
[basename(1)]: http://man.cx/basename(1)
[tar(1)]: http://man.cx/tar(1)
[zip(1)]: http://man.cx/zip(1)
[unzip(1)]: http://man.cx/unzip(1)
[compress(1)]: http://man.cx/compress(1)
[gzip(1)]: http://man.cx/gzip(1)
[gunzip(1)]: http://man.cx/gunzip(1)
[pdflatex(1)]: http://man.cx/pdflatex(1)
[openssl(1)]: http://man.cx/openssl(1)
[scp(1)]: http://man.cx/scp(1)
[ssh(1)]: http://man.cx/ssh(1)
[rsync(1)]: http://man.cx/rsync(1)
[autoreconf(1)]: http://man.cx/autoreconf(1)
[checkbashisms(1)]: http://man.cx/checkbashisms
[growlnotify(1)]: http://scottlab.ucsc.edu/Library/init/zsh/man/html/growlnotify.html
[sendmail(1)]: http://man.cx/sendmail(1)
[uuencode(1)]: http://man.cx/uuencode(1)
[epxand(1)]: http://man.cx/expand(1)
[unepxand(1)]: http://man.cx/unexpand(1)
[git(1)]: http://git-scm.com/
[ronn(1)]: https://github.com/rtomayko/ronn
[github(7)]: http://github.com/
[json-sh(1)]: https://github.com/dominictarr/JSON.sh
[npm(1)]: http://npmjs.org
[ruby(3)]: http://www.ruby-lang.org/
[rake(1)]: http://rake.rubyforge.org/
[semver(7)]: http://semver.org/
[ant(1)]: http://ant.apache.org/
[mvn(1)]: http://maven.apache.org/
[make(1)]: http://www.gnu.org/software/make/
[jsonlint(1)]: https://github.com/zaach/jsonlint
[jsoncheck(1)]: http://json.org/JSON_checker/
[ere(7)]: http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html
[couchdb(7)]: http://couchdb.apache.org/
[url(7)]: http://www.ietf.org/rfc/rfc1738.txt
[array-file(3)]: array-file.3.html
[array(3)]: array.3.html
[console(1)]: console.1.html
[console(3)]: console.3.html
[delegate(3)]: delegate.3.html
[executable(3)]: executable.3.html
[git(3)]: git.3.html
[globals(3)]: globals.3.html
[help(3)]: help.3.html
[json(3)]: json.3.html
[manual(1)]: manual.1.html
[prompt(1)]: prompt.1.html
[prompt(3)]: prompt.3.html
[semver(3)]: semver.3.html
[sprintf(3)]: sprintf.3.html
[strike-credits(7)]: strike-credits.7.html
[strike-tree(7)]: strike-tree.7.html
[strike(7)]: strike.7.html
[task-ant(7)]: task-ant.7.html
[task-archive(7)]: task-archive.7.html
[task-clean(7)]: task-clean.7.html
[task-compress(7)]: task-compress.7.html
[task-deploy-json(7)]: task-deploy-json.7.html
[task-deploy(7)]: task-deploy.7.html
[task-devel(7)]: task-devel.7.html
[task-doc(7)]: task-doc.7.html
[task-expand(7)]: task-expand.7.html
[task-latex(7)]: task-latex.7.html
[task-ls(7)]: task-ls.7.html
[task-make(7)]: task-make.7.html
[task-module(7)]: task-module.7.html
[task-mvn(7)]: task-mvn.7.html
[task-project(7)]: task-project.7.html
[task-rake(7)]: task-rake.7.html
[task-semver(7)]: task-semver.7.html
[task-test(7)]: task-test.7.html
[task-todo(7)]: task-todo.7.html
[version(3)]: version.3.html
