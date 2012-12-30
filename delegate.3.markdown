delegate(3) -- method delegation
=============================================

## SYNOPSIS

Provides the main delegate entry point for programs that wish to map command options to method invocations and provides modules with a default delegate where no main module method has been declared.

## DESCRIPTION

A module may declare a `main` method which should have the same name as the module. The require(3) module is a good example of a module which does this. If a main method is not declared and the `delegate` method is available then a dynamic method is created which invokes delegate(3). This allows for useful behaviour such as to map a command line option to a module method invocation.

## USAGE

	delegate "module" "method" "${options[@]:-}";
	
## EXAMPLE

Suppose you had a `say` module with the following code:

	declare -gx say_greeting="world";
	say.hello() {
		console.info "hello %s" "$say_greeting";
	}
	
	say.goodbye() {
		console.info "goodbye %s" "$say_greeting";
	}
	
And then included the module in your program using require(3):

	require 'say';
	
The `say` module would automatically have a dynamic delegate(3) method created (called `say`) which allows for invocations such as:

	say hello && say goodbye;

## BUGS

**delegate** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**delegate** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

require(3)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[USAGE]: #USAGE "USAGE"
[EXAMPLE]: #EXAMPLE "EXAMPLE"
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
