# Strike

Modular `bash` using `require`. Depends upon `bash >= 4` for associative arrays.

## Installation

	npm install strike
	
## Synopsis

Brings structure and modularity to `bash` programs and provides a set of modules that can be used from any `bash` program.

## Boilerplate

Before using the library functions you need to include some boilerplate code which is responsible for determining the filesystem path to the executable (including resolving symbolic links), if you have installed the `strike` library as a node module and your executable is in a `bin` directory (sibling of the `node_modules` directory) the boilerplate would look like:

	######################################################################
	#
	#	BOILERPLATE
	#
	######################################################################
	abspath=$(cd ${BASH_SOURCE[0]%/*} && echo $PWD/${0##*/});
	if [ -L "$abspath" ]; then
		abspath=`readlink $abspath`;
	fi
	exedir=`dirname "$abspath"`;
	libdir="$exedir/../node_modules/strike/lib";
	source "$libdir/shared";
	######################################################################

The `exedir` is the path to the directory containing the executable and the `libdir` must point to the directory containing the library code. Once the library code is sourced you can use the modules documented below. You may need to modify the `libdir` path depending upon the filesystem structure of your code.

Once the library code has been included the following modules are automatically available to your code:

* method
* color
* console
* main
* string
* fs

## Modules

### method

Provides utility functions for determining whether functions exist, listing functions and removing methods.

### color

Functions used for including terminal colors in console output.

### console

Core methods for generating program output providing a standard output format and syntax.

### main

Delegate functionality to provide the main entry point for programs and aliased for modules that do not declare a main method.

### require

This is the core module used to `require` other modules.

#### Usage

For example to `require` the `http` module:

	require 'http';
	
#### Pseudo Constructor

If a module declares a (pseudo) *constructor* function then it is invoked when it is required.

The convention for this *pseudo-constructor* is module name + `_initialize` so in the above example the `http` module does have a constructor named `http_initialize` which is responsible for ensuring that the directory used to store `http` related files always exists.

#### Main Method Delegate

A module may declare a `main` method which should have the same name as the module. The `require` module is a good example of a module which does this; if a main method is not declared and the core `main` method is available then the module main method is aliased to the `main` delegate. This allows for useful behaviour, continuing the `http` example which does not declare a main method and is decorated with the delegate functionality, such as:

	require 'http';
	http request.add.header "content-type: application/json";
	
Which can be very helpful when you want to map a command line option to a module method invocation.