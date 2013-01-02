console(3) -- console output
=============================================

## SYNOPSIS

Helper methods for printing ANSI formatted output to a terminal and redirecting output to log file(s).

## DESCRIPTION

The console(3) module is a built in module available to all programs. It is responsible for printing messages with optional replacement parameters which are highlighted when the message is printed.

If either stdout or stderr is not a *tty* then formatting of the output message is not performed which means that when redirecting to a file the ANSI sequence is omitted and the string is passed with parameter replacement performed but *no formatting*.

## USAGE

The general syntax for printing output is:

console.info "message to print with %s information" "important";
	
Whereby the `%s` substring in the main message will be highlighted and replaced with the string *important*, generating:

message to print with `important` information

## STDOUT

To print to standard output use the following methods.

* `console.info`:

	Prints an informational message.
	
* `console.log`:

	Prints a log message. This method *does not perform any formatting* or print any program (or message type prefix) but does provide parameter replacement. This method is essentially just a wrapper for echo(1) that allows the use of parameter replacement and the log file redirection functionality.
	
## STDERR

To print to standard error use the following methods.

* `console.warn`:

	Prints a warning message.
	
* `console.error`:

	Prints an error message.
	
* `console.throw`:

	Prints an error message followed by a stack trace of the current method call stack.
	
## LOG FILE REDIRECTION

The console(3) module supports redirecting stdout/stderr to log file(s). 

* `console.log.stdout`:

	Redirect stdout to a log file and store stdout in file descriptor #3.
	
* `console.log.stdout.close`:

	Close redirection of stdout, restoring stdout and closing file descriptor #3.
	
* `console.log.stderr`:

	Redirect stderr to a log file and store stderr in file descriptor #4.

* `console.log.stderr.close`:

	Close redirection of stderr, restoring stderr and closing file descriptor #4.
	
## EXIT METHODS

The console(3) module provides methods for exiting the program (optionally with a formatted message).

* `console.success`:

	Marks the program as completed successfully (exiting with a zero exit code) and optionally prints a formatted message.

* `console.quit`:

	Exits the program with a non-zero exit code and optional error message. Note that the signature for this method differs from the general syntax for console(3) methods as it expects the first parameter to be the exit code.
	
## OPTIONS

The console(3) module parses the program options (but does not modify them) looking for the following options:

* `--no-format`:

	Do not perform any ANSI color or formatting modifications to the output.
	
## VARIABLES

See the globals-api(3) documentation.
	
## MISCELLANEOUS

You may also print a stack trace (without any preceeding error message) using the `console.trace` method. Note that this method does not follow the general syntax for console(3) method invocations and accepts no parameters.

## BUGS

The number of replacement parameters must match exactly the number of `%s` occurences in the message otherwise unexpected behaviour will occur.

**console** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**console** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

globals-api(3)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[USAGE]: #USAGE "USAGE"
[STDOUT]: #STDOUT "STDOUT"
[STDERR]: #STDERR "STDERR"
[LOG FILE REDIRECTION]: #LOG-FILE-REDIRECTION "LOG FILE REDIRECTION"
[EXIT METHODS]: #EXIT-METHODS "EXIT METHODS"
[OPTIONS]: #OPTIONS "OPTIONS"
[VARIABLES]: #VARIABLES "VARIABLES"
[MISCELLANEOUS]: #MISCELLANEOUS "MISCELLANEOUS"
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
[array(3)]: array.3.html
[console(3)]: console.3.html
[delegate(3)]: delegate.3.html
[executable(3)]: executable.3.html
[globals-api(3)]: globals-api.3.html
[help(7)]: help.7.html
[json(3)]: json.3.html
[strike-credits(7)]: strike-credits.7.html
[strike-tree(7)]: strike-tree.7.html
[strike(7)]: strike.7.html
[task-clean(7)]: task-clean.7.html
[task-doc(7)]: task-doc.7.html
[task-list(7)]: task-list.7.html
[task-test(7)]: task-test.7.html
