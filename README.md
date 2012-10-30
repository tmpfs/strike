# Strike

A suite of utility functions for *bash* programs.

## Repository Layout

### bin

Contains executables for running tests and inspecting the host system.

#### host

A utility program for inspecting information about the host system.

	host
	
#### runner

The test runner, to run all tests:

	runner

### lib

The main library functions are located in the `lib` directory.

### test

Tests and the test library functions are located in the `test` directory.
	
When writing tests for failure situations; those that expect a non-zero exit status to indicate that the test has passed must prefix the name of the test program with `fail`.

## Conventions

Functions in `bash` can only return integer values so the convention is to assign a function's return value to the `_result` global variable which can subsequently be accessed with `$_result`.

## Dependencies

In addtion to `bash` external program dependencies are listed here:

* `basename`
* `dirname`
* `type`
* `id`
* `echo`
* `find`
* `tar`
* `zip`
* `du`
* `ln`
* `rm`
* `cd`
* `cp`
* `mkdir`
* `touch`