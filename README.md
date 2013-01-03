# Strike

Modular `bash` using `require` for *NIX systems. Depends upon `bash >= 4` for associative arrays.

## Synopsis

Brings structure and modularity to `bash` programs and provides a set of modules that can be used from any `bash` program.

## Semantic Versioning

This software is currently under development in the 0.x.x version range and is released using the [semver(7)](http://semver.org/) semantic versioning specification.

## Features

### Core

* Write portable and maintainable code using [require(3)](http://freeformsystems.github.com/strike/require.3.html)
* Make your program pretty, use [console(3)](http://freeformsystems.github.com/strike/console.3.html) for [ANSI escape sequences](http://en.wikipedia.org/wiki/ANSI_escape_code)
* Improve code legibility without sacrificing terseness by using the various helper modules such as [method(3)](http://freeformsystems.github.com/strike/method.3.html), [array(3)](http://freeformsystems.github.com/strike/array.3.html) and [string(3)](http://freeformsystems.github.com/strike/string.3.html)
* Use [delegate(3)](http://freeformsystems.github.com/strike/delegate.3.html) to easily map options to command methods

### Process

* Be safe, declare `process.use strict`
* Daemonize any process with `process.daemon.start!`
* Make a process behave as a singleton with `process.lock.use!`
* Easily add PID file management with `process.pid.use!`
* Map trap signals to command methods with the `process.signal.*` commands, see [process(3)](http://freeformsystems.github.com/strike/process.3.html)

### Test

* Write test-driven programs using the `test` task for [bake(1)](http://freeformsystems.github.com/strike/bake.1.html)
* Use [assert(3)](http://freeformsystems.github.com/strike/assert.3.html) to perform inline assertions

### Documentation & Help

* Document your program using inline heredoc comments and publish to html and man pages using the `doc.*` tasks for [bake(1)](http://freeformsystems.github.com/strike/bake.1.html)
* Publish documentation as github pages with the `doc.pages.publish` [bake(1)](http://freeformsystems.github.com/strike/bake.1.html) task
* Easily display program help as man pages with [help(3)](http://freeformsystems.github.com/strike/help.3.html)

### Extensions & Executables

* Read and write JSON data using [json(3)](http://freeformsystems.github.com/strike/json.3.html)
* Use [bake(1)](http://freeformsystems.github.com/strike/bake.1.html) to automate common tasks
* Intermingle [rake(1)](http://rake.rubyforge.org/) with [bake(1)](http://freeformsystems.github.com/strike/bake.1.html) tasks if you like

## Installation

To install the library code as a dependency for a project into the `node_modules` sub-folder use:

	npm install strike
	
If you want the supplied executables to be available in `$PATH` use the global flag:

	npm install -g strike
	
## Documentation

The [project documentation](http://freeformsystems.github.com/strike) is available as html man pages.

## Developers

### Running Tests

Use `bake(1)` to execute the unit tests, run:

	npm test
	
Which is an alias for:

	./bake test

### Generating Documentation

Documentation for the repository is generated using [ronn(1)](https://github.com/rtomayko/ronn) which must be installed, to generate documentation use task-doc(7):

	npm run-script doc
	
Which is an alias for:

	./bake doc.build
	
Note that currently you will need to apply [this patch](https://github.com/rtomayko/ronn/issues/69) to [ronn(1)](https://github.com/rtomayko/ronn) for documentation to build correctly.

## License

Everything is [MIT](http://en.wikipedia.org/wiki/MIT_License). Read the [license](/freeformsystems/strike/blob/master/LICENSE) if you feel inclined.