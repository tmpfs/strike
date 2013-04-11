manual(1) -- interactive man page browser
=============================================

## SYNOPSIS

	manual [command] [options...]

## DESCRIPTION

An interactive program for viewing the strike(7) manual pages. Tab completion
is performed on the available man pages and interactive commands (with the
exception of the *help* command).

You may use the following sequences to exit the program:

* q
* quit
* exit

## COMMANDS

* `help`:

	Show the manual(1) man page.

## OPTIONS

* `--version`:

	Print the program version and exit.

* `--color=auto|never|always`:

	Change the configuration for printing ANSI color escape sequences.
	The default value is *auto*. See sprintf(3).

## INTERACTIVE COMMANDS

The following commands are available from the interactive prompt.


* `name.[1-8]`:

	Open *name* manual page using man(1).


* `ls`:

	List available manual pages.

* `?`:

	Print command usage.

* `help`:

	Display this manual page.

## DEVELOPER COMMANDS

These commands are designed to be used by developers.

* `build`:

	Command to build the man pages from the markdown source, 
	requires ronn(1). This is an alias for the task-doc(7) command that
	corresponds to `bake doc man build`.

* `generate`:

	Command to build the ronn documents from inline heredoc comments.
	This is an alias for the task-doc(7) command that
	corresponds to `bake doc man generate`.

* `compile`:

	Command to compile all ronn documents to manual pages, 
	requires ronn(1). This is an alias for the task-doc(7) command that
	corresponds to `bake doc man compile`.

* `import`:

	Import compiled manual pages into the man directory.
	This is an alias for the task-doc(7) command that
	corresponds to `bake doc man import`.

* `clean`:

	Remove compiled manual pages from the man directory.
	This is an alias for the task-doc(7) command that
	corresponds to `bake doc man clean`.

## EXAMPLES

Launch the interactive browser:

	manual

Display this manual page:

	manual help

Switch off the color capability:

	manual --color=never

Print program version and exit:

	manual --version

## BUGS

**manual** is written in bash and depends upon `bash` >= 4.2.

## COPYRIGHT

**manual** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

man(1), sprintf(3), task-doc(7), ronn(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[COMMANDS]: #COMMANDS "COMMANDS"
[OPTIONS]: #OPTIONS "OPTIONS"
[INTERACTIVE COMMANDS]: #INTERACTIVE-COMMANDS "INTERACTIVE COMMANDS"
[DEVELOPER COMMANDS]: #DEVELOPER-COMMANDS "DEVELOPER COMMANDS"
[EXAMPLES]: #EXAMPLES "EXAMPLES"
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
