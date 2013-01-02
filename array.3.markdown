array(3) -- array module
=============================================

## SYNOPSIS

Module methods for writing, reading, modifiying and inspecting arrays.

## DESCRIPTION

The array(3) modules can be used to write *global* array(s) to file(s) and read the file(s) back into array declarations.

## USAGE

To write an array file, declare the *global* array(s) and call `array.write`.

	write_array() {
		local file="${program_dirs[root]}/arrays";
		declare -a array1;
		array1=( 3 2 1 "a test string" );
		declare -A array2;
		array2[key]="value";
		array2[greeting]="hello world";
		array.write "$file" <<< "array1 array2";	# specify the array names on stdin
	}
	write_array;
	
To read an array file back into array(s) use the `array.read` method.

	read_array() {
		local file="${program_dirs[root]}/arrays";
		array.read < "$file";						# read from the `arrays` file
		
		# print array keys
		console.log "${!array1[*]}";
		console.log "${!array2[*]}";
		
		# print array values
		console.log "${array1[*]}";
		console.log "${array2[*]}";
	}
	read_array;

## BUGS

When writing and reading arrays, the variable declarations must by *global*.

Attempting to write and read associative arrays with spaces in the *keys* will result in unexpected behaviour.

**array** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**array** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

require(3)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[USAGE]: #USAGE "USAGE"
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
