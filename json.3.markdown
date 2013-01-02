json(3) -- JSON manipulation
=============================================

## SYNOPSIS

An experimental module for parsing and stringifying JSON data.

## DESCRIPTION

The json(3) module adds methods for parsing and creating JSON documents.

## USAGE

Parsing JSON data can be from a file, string or variable. After parsing the JSON data the parsed data is available on the global `json_doc` associative array. Use the `json.print` method to quickly inspect the contents of the parsed data.

	require 'json';
	
	# parse a json document
	json.parse < "${program_dirs[root]}/package.json";
	json.print;
	
	# parse a json string
	json.parse <<< '{ "data": "value" }';
	json.print;
	
	# clean up parsed json data
	json.clean;
	
Converting to JSON is achieved using references to variable names and afterwards the JSON string is available in the global `json_str` variable. Use the `json.string` method to print the JSON string data.

	require 'json';

	toJSON() {
		declare -A doc;
		doc[key]="value";
		doc[greeting]="hello world";
		json.stringify <<< "doc";		# doc is the *name* of the variable to stringify
		json.string;					# print the result
	}
	toJSON;

## BUGS

**json** is written in bash and depends upon `bash` >= 4.

The json(3) module is derived from json-sh(1).

## COPYRIGHT

**json** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

strike(7)


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
