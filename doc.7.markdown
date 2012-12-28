tasks-doc(7) -- documentation tasks for bake
=============================================

## SYNOPSIS

Collection of documentation tasks for bake(1).

## DESCRIPTION

Adds task methods for generating and compiling inline heredoc documentation.

## USAGE

In your tasks(7) file `require` the `doc` tasks using:

	require 'tasks/doc';

## METHODS

The following commands are then available to bake(1):

* `doc.all`:
	Invokes `doc.generate`, `doc.compile` and `doc.man.import`.

* `doc.generate`:
	Searches the doc search paths and attempts to find inline heredoc declarations in any files within the search paths. When an inline heredoc is encountered a corresponding `.ronn` file is generated in `${target}/doc`.
	
* `doc.compile`:
	Compiles any `.ronn` documents previously generated using the `doc.generate` task.

## BUGS

**tasks-doc** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**tasks-doc** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

bake(1), strike(1), require(7)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[USAGE]: #USAGE "USAGE"
[METHODS]: #METHODS "METHODS"
[BUGS]: #BUGS "BUGS"
[COPYRIGHT]: #COPYRIGHT "COPYRIGHT"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[strike(1)]: 	strike.1.html
[boilerplate(3)]: boilerplate.3.html
[require(3)]: 	require.3.html
[method(3)]: 	method.3.html
[http(7)]: 	http.1.html
[bake(1)]: 	bake.1.html
[rest(1)]: 	rest.1.html
[curl(1)]: 	http://man.cx/curl(1).html
[tee(1)]: 		http://man.cx/tee(1).html
[assert(1)]: assert.html
[bake(1)]: bake.html
[boilerplate(3)]: boilerplate.html
[tasks-doc(7)]: doc.html
[help(7)]: help.html
[http(7)]: http.html
[rest(1)]: rest.html
[strike(1)]: strike.html
