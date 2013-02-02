# Strike

Modular `bash` using [require(3)](http://freeformsystems.github.com/strike/require.3.html) for *NIX systems. Depends upon `bash >= 4.2` for some useful features.

## Synopsis

Brings structure and modularity to `bash` programs and provides a set of modules that can be used from any `bash` program.

## Semantic Versioning

This software is currently under development in the 0.x.x version range and is released using the [semver(7)](http://semver.org/) semantic versioning specification.

## Features

### Core

* Write portable and maintainable code using [require(3)](http://freeformsystems.github.com/strike/require.3.html)
* Make your program pretty, use [console(3)](http://freeformsystems.github.com/strike/console.3.html) for [ANSI escape sequences](http://en.wikipedia.org/wiki/ANSI_escape_code)
* Improve code legibility without sacrificing terseness by using the various helper modules such as [method(3)](http://freeformsystems.github.com/strike/method.3.html), [array(3)](http://freeformsystems.github.com/strike/array.3.html) and [string(3)](http://freeformsystems.github.com/strike/string.3.html)
* Use [delegate(3)](http://freeformsystems.github.com/strike/delegate.3.html) to easily map options to commands

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
* Publish documentation as github pages with the `doc.pages.push` [bake(1)](http://freeformsystems.github.com/strike/bake.1.html) task
* Easily display program help as man pages with [help(3)](http://freeformsystems.github.com/strike/help.3.html)

### Extensions & Executables

* Read and write JSON data using [json(3)](http://freeformsystems.github.com/strike/json.3.html)
* Use [bake(1)](http://freeformsystems.github.com/strike/bake.1.html) to automate common tasks
* Intermingle [rake(1)](http://rake.rubyforge.org/) with [bake(1)](http://freeformsystems.github.com/strike/bake.1.html) tasks if you like

## Prerequisites

* [bash](http://www.gnu.org/software/bash/) >= 4.2

Most modern distributions ship with the binaries that some parts of the library depend upon. However on extremely minimal distributions you should install the list below.

It is recommended (although not essential) that you have these executables:

* [git(1)](http://git-scm.com/)
* [curl(1)](http://curl.haxx.se/)

BSD users (that's OS X users too) should install GNU versions for `find(1)` and `tar(1)`.

* [find(1)](http://www.gnu.org/software/findutils/)
* [tar(1)](http://www.gnu.org/software/tar/) >= 1.22

## Installation

To install the library code as a dependency for a project into the `node_modules` sub-folder use:

	npm install strike
	
If you want the supplied executables to be available in `$PATH` use the global flag:

	npm install -g strike
	
## Documentation

The [project documentation](http://freeformsystems.github.com/strike) is available as html man pages.

## Developers

Developers should have [node(1)](http://nodejs.org) (which includes [npm(1)](http://npmjs.org)) in order to run the tests.

### Running Tests

For illustrative purposes the `./bake test` runner is also available using the following commands:

If you prefer [npm(1)](http://npmjs.org) use the `test` command:

	npm test
	
If you prefer [rake(1)](http://rake.rubyforge.org/) use the `test` task:

	rake test
	
If you prefer [ant(1)](http://ant.apache.org/) use the `test` target:

	ant test
	
If you prefer [mvn(1)](http://maven.apache.org/) use the `test` goal:

	mvn test
	
To verify all build tools are executing tests correctly use this one-liner:

	npm test && rake test && ant test && mvn test && ./bake test

#### Dependencies

Some dependencies required to run the tests that may not be available on very minimal installations:

* zip(1)
* unzip(1)
* tar(1)
* man(1)

In addition it is recommended for all tests to run that you have the following executables and an active internet connection:

* gcc(1)
* curl(1)
* pdflatex(1)
* [jsonlint(1)](https://github.com/zaach/jsonlint)

### Generating Documentation

Documentation for the repository is generated using [ronn(1)](https://github.com/rtomayko/ronn) which must be installed, to generate documentation use task-doc(7):

	npm run-script doc
	
Which is an alias for:

	./bake doc.build
	
Note that currently you will need to apply [this patch](https://github.com/rtomayko/ronn/issues/69) to [ronn(1)](https://github.com/rtomayko/ronn) for documentation to build correctly.

## License

Everything is [MIT](http://en.wikipedia.org/wiki/MIT_License). Read the [license](/freeformsystems/strike/blob/master/LICENSE) if you feel inclined.