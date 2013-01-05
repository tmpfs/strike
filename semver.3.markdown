semver(3) -- semantic version parser
=============================================

## SYNOPSIS

Commands for working with semantic versioning as defined by semver(7).

## DESCRIPTION

Enables parsing of semantic version strings to complex objects.

## USAGE

To parse a semver(7) string into an associative array use `semver.parse` with the string and a callback method:

	require 'semver';
	callback() {
		console.info "semver keys %s" "${!semver[*]}";
		console.info "semver values %s" "${semver[*]}";
		semver.stringify;
		console.info "semver string %s" "$_result";
	}
	semver.parse "2.0.0-rc" "callback";
	
Note that the `semver.parse` method will not perform any operations on invalid semver(7) string values, you may invoke `semver.valid?` to test the validity of a string.

## BUGS

**semver** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**semver** is copyright (c) 2012 muji <http://xpm.io>

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
[find(1)]: http://man.cx/find(1)
[tee(1)]: http://man.cx/tee(1)
[ronn(1)]: https://github.com/rtomayko/ronn
[github(7)]: http://github.com/
[json-sh(1)]: https://github.com/dominictarr/JSON.sh
[npm(1)]: http://npmjs.org
[ruby(3)]: http://www.ruby-lang.org/
[rake(1)]: http://rake.rubyforge.org/
[semver(7)]: http://semver.org/
[sed(1)]: http://man.cx/sed(1)
[ant(1)]: http://ant.apache.org/
[printf(1)]: http://man.cx/printf(1)
[source(1)]: http://man.cx/source(1)
[array(3)]: array.3.html
[console(3)]: console.3.html
[delegate(3)]: delegate.3.html
[executable(3)]: executable.3.html
[git(3)]: git.3.html
[globals-api(3)]: globals-api.3.html
[help(7)]: help.7.html
[json(3)]: json.3.html
[semver(3)]: semver.3.html
[strike-credits(7)]: strike-credits.7.html
[strike-tree(7)]: strike-tree.7.html
[strike(7)]: strike.7.html
[task-ant(7)]: task-ant.7.html
[task-clean(7)]: task-clean.7.html
[task-doc(7)]: task-doc.7.html
[task-list(7)]: task-list.7.html
[task-rake(7)]: task-rake.7.html
[task-semver(7)]: task-semver.7.html
[task-test(7)]: task-test.7.html
[task-todo(7)]: task-todo.7.html
