# Strike

Modular `bash` using `require` for *NIX systems. Depends upon `bash >= 4` for associative arrays.

## Synopsis

Brings structure and modularity to `bash` programs and provides a set of modules that can be used from any `bash` program.

## Installation

To install the library code as a dependency for a project into the `node_modules` sub-folder use:

	npm install strike
	
If you want the supplied executables to be available in `$PATH` use the global flag:

	npm install -g strike
	
## Documentation	

The [project documentation](http://freeformsystems.github.com/strike) is available as html man pages.

## Developers

### Running Tests

Use `bake(1)` to execute the unit tests:

	./bake assert

### Generating Documentation

Documentation for the repository is generated using [ronn(1)](https://github.com/rtomayko/ronn) which must be installed, to generate documentation use task-doc(7):

	./bake doc.build
	
Note that currently you will need to apply [this patch](https://github.com/rtomayko/ronn/issues/69) to [ronn(1)](https://github.com/rtomayko/ronn) for documentation to build correctly.

## License

Everything is [MIT](http://en.wikipedia.org/wiki/MIT_License). Read the [license](/freeformsystems/strike/blob/master/LICENSE) if you feel inclined.