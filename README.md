# Strike

Modular `bash` using `require` for *NIX systems. Depends upon `bash >= 4` for associative arrays.

## Synopsis

Brings structure and modularity to `bash` programs and provides a set of modules that can be used from any `bash` program.

## Features

* Encourages safe scripting with `process.use strict`
* Daemonize any process with `process.daemon.start!`
* Make a process behave as a singleton with `process.lock.use!`
* Easily add PID file management to a process with `process.pid.use!`
* Write portable and maintainable code using require(3)

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