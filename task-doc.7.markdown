task-doc(7) -- documentation task(s) for bake(1)
=============================================

## SYNOPSIS

Collection of documentation tasks for bake(1).

## DESCRIPTION

Adds task methods for generating and compiling inline heredoc documentation.

## REQUIRE

In your tasks(7) file `require` the `doc` task(s) using:

	require 'tasks/doc';

## USAGE

	bake doc.build

## METHODS

The following commands are then available to bake(1):

* `doc.all`:
	Invokes `doc.build` and `doc.pages.publish`.

* `doc.build`:
	Invokes `doc.generate`, `doc.compile` and `doc.man.import`.

* `doc.generate`:
	Searches the doc search paths and attempts to find inline heredoc declarations in any files within the search paths. When an inline heredoc is encountered a corresponding `.ronn` file is generated in `${target}/doc`.
	
	If a file is encountered that has a `.ronn` extension then that file is not parsed for heredoc declarations but is copied to the output directory for inclusion in the generated documentation.
	
* `doc.compile`:
	Compiles any `.ronn` documents previously generated using the `doc.generate` task.
	
* `doc.pages.publish`:
	Switches to a `gh-pages` branch, copies over generated documentation before pushing the `gh-pages` branch to github(7). The `gh-pages` branch must already exist for this command to succeed.
	
* `doc.man.import`:
	Copies compiled man pages into `${root}/man`.
	
* `doc.man.clean`:
	Removes man pages from `${root}/man`.

## BUGS

**task-doc** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**task-doc** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

bake(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[REQUIRE]: #REQUIRE "REQUIRE"
[USAGE]: #USAGE "USAGE"
[METHODS]: #METHODS "METHODS"
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
[tee(1)]: http://man.cx/tee(1)
[ronn(1)]: https://github.com/rtomayko/ronn
[github(7)]: http://github.com/
[json-sh(1)]: https://github.com/dominictarr/JSON.sh
[npm(1)]: http://npmjs.org
[ruby(3)]: http://www.ruby-lang.org/
[rake(1)]: http://rake.rubyforge.org/
[semver(7)]: http://semver.org/
[printf(1)]: http://man.cx/printf(1)
[source(1)]: http://man.cx/source(1)
[array(3)]: array.3.html
[console(3)]: console.3.html
[delegate(3)]: delegate.3.html
[executable(3)]: executable.3.html
[globals-api(3)]: globals-api.3.html
[help(7)]: help.7.html
[json(3)]: json.3.html
[semver(3)]: semver.3.html
[strike-credits(7)]: strike-credits.7.html
[strike-tree(7)]: strike-tree.7.html
[strike(7)]: strike.7.html
[task-clean(7)]: task-clean.7.html
[task-doc(7)]: task-doc.7.html
[task-list(7)]: task-list.7.html
[task-rake(7)]: task-rake.7.html
[task-test(7)]: task-test.7.html
