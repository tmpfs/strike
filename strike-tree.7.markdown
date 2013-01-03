strike-tree(7) -- filesystem structure for strike(7)
=============================================

## SYNOPSIS

Although it is *not mandatory* it is recommended (for maximum portability and consistency) that you follow a convention for the filesystem structure which is shown below.

	|-- bin
	|-- doc
	|-- lib
	|	|-- modules
	|		|-- doc
	|		|-- tasks
	|-- man
	|-- target
	|-- test
	
## BIN

Executable files should be placed in the `bin` directory.

## DOC

Auxiliary files for man page documentation (index.html, index.txt etc) should be placed in the `doc` directory.

## LIB

Library functions can be placed in the `lib` directory. Note that files in this directory are not included when generating documentation using task-doc(7), for inline documentation use a module. 

## MODULES

Modules for the program **must** be in the `lib/modules` directory in order for require(3) to find your modules correctly when no relative or absolute path to the module has been specified.

## MODULES/DOC

If you use `.ronn` files in addition to the inline documentation functionality it is recommended that they are placed in `lib/modules/doc`.

## TASKS

Any program-specific tasks for bake(1) should be placed in `lib/modules/tasks`.

## MAN

The `man` directory is where task-doc(7) will place generated man pages.

## TARGET

The `target` directory is used by bake(1) for staging, logging and any other temporary files, this directory should be ignored by any source code management tool such as git(1).

## TEST

Unit test files are searched for in the `test` directory when task-test(7) runs.

## SEE ALSO

strike(7)

[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[BIN]: #BIN "BIN"
[DOC]: #DOC "DOC"
[LIB]: #LIB "LIB"
[MODULES]: #MODULES "MODULES"
[TASKS]: #TASKS "TASKS"
[MAN]: #MAN "MAN"
[TARGET]: #TARGET "TARGET"
[TEST]: #TEST "TEST"
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
