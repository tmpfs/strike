task-todo(7) -- todo task(s) for bake(1)
=============================================

## SYNOPSIS

Task(s) for bake(1) to find *TODO* tags in a project.

## DESCRIPTION

Adds task methods for scanning a project looking for *TODO* tags, use these commands to give your code a sanity check.

## REQUIRE

In your tasks(7) file `require` the `todo` task(s) using:

	require 'tasks/todo';

## USAGE

	bake todo [commands...] [flags...]
	
## COMMANDS

This section describes the command options for task-todo(7). When no command is specified the default behaviour is to call the `scan` command.

* `scan`:

Scan the project `${root}` for files and print *TODO* tags information.
	
The format of the output for each tag found is a comment line (preceeded by a '#' character and a single space) with the tag converted to uppercase followed by a space and then the file path concatenated with the line number using a ':' delimiter, for example:

	# TODO /path/to/project/bin/bake:358
	this is a todo message
	
Output for *BUG* and *FIXME* tags found is redirected to stderr, all other tags found are sent to stdout. This enables easy redirection of these tags to a file using a command such as:

	bake todo scan 2> target/todo.err.log

* `tags`:

The `tags` command prints a list of tag identifiers and the corresponding pattern used to match a tag.
	
The output format for this command is an uppercase tag identifier delimited by the equals sign '=' followed by the pattern used to match the tag.

* `list`:

Use the `list` command to print a list of the files that a scan would match.

* `count`:

Count occurences of tags, this implies the `--silent` option. The format of count output is an uppercase tag name and the count value delimited by an '=' character, for example:

	TODO=76
	
* `excludes`:

Prints the exclude patterns.

## OPTIONS

Options for task-todo(7).

* `--dir`:

Add one or more directories *relative to the project root* to scan for tags. This removes all default directory scans and performs a custom scan using *only* the directories specified on the command line. For example:

	bake todo scan --dir bin --dir src --bug --fixme
	
* `--file`:

Add one or more files to the list of files to scan.

	bake todo scan --file bin/bake
	
If a file path starts with the pattern '(\.+)?/' then it will be treated as an absolute file path, otherwise the file is treated as relative to `${root}`.

## FLAGS

Flag options for task-todo(7).

* `--silent`:

Makes task-todo(7) mute, this is useful if you are only interested in the exit code.

## FILTER FLAGS

You may specify any tag as an option to switch on tag filtering, when any filter tag option is specified, then only the tags specified are matched. For example, to match only *BUG* tags, use:

	bake todo scan --bug
	
But to include any other tags they must now be specified, so to find *TODO* and *NOTE* tags, use:

	bake todo scan --todo --note

* `--bug`:

Filter for *BUG* tag matches.

* `--fixme`:

Filter for *FIXME* tag matches.

* `--todo`:

Filter for *TODO* tag matches.

* `--note`:

Filter for *NOTE* tag matches.

* `--xxx`:

Filter for *XXX* tag matches.

* `--changed`:

Filter for *CHANGED* tag matches.

* `--deprecated`:

Filter for *DEPRECATED* tag matches.

## TAGS

The following tags are supported by default:

* `BUG`:
	
To mark a known bug.

* `FIXME`:
	
To mark potential problematic code that requires special attention and/or review.

* `TODO`:
	
To indicate planned enhancements.

* `NOTE`:

To document inner workings of code and indicate potential pitfalls.

* `XXX`:

To warn other programmers of problematic or misguiding code.

* `CHANGED`:

To indicate that behaviour or implementation has changed.

* `DEPRECATED`:

To mark code as deprecated.

## EXIT CODES

If any *BUG* or *FIXME* tags are encountered then the program exits with a >0 exit code which is the total number of *BUG* and *FIXME* tags found, otherwise 0.

## DEPENDENCIES

find(1)

## BUGS

**task-todo** is written in bash and depends upon `bash` >= 4.2.

## COPYRIGHT

**task-todo** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

bake(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[REQUIRE]: #REQUIRE "REQUIRE"
[USAGE]: #USAGE "USAGE"
[COMMANDS]: #COMMANDS "COMMANDS"
[OPTIONS]: #OPTIONS "OPTIONS"
[FLAGS]: #FLAGS "FLAGS"
[FILTER FLAGS]: #FILTER-FLAGS "FILTER FLAGS"
[TAGS]: #TAGS "TAGS"
[EXIT CODES]: #EXIT-CODES "EXIT CODES"
[DEPENDENCIES]: #DEPENDENCIES "DEPENDENCIES"
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
[bash(1)]: http://man.cx/bash(1)
[curl(1)]: http://man.cx/curl(1)
[echo(1)]: http://man.cx/echo(1)
[find(1)]: http://man.cx/find(1)
[tee(1)]: http://man.cx/tee(1)
[sed(1)]: http://man.cx/sed(1)
[printf(1)]: http://man.cx/printf(1)
[source(1)]: http://man.cx/source(1)
[dirname(1)]: http://man.cx/dirname(1)
[basename(1)]: http://man.cx/basename(1)
[tar(1)]: http://man.cx/tar(1)
[zip(1)]: http://man.cx/zip(1)
[unzip(1)]: http://man.cx/unzip(1)
[compress(1)]: http://man.cx/compress(1)
[gzip(1)]: http://man.cx/gzip(1)
[gunzip(1)]: http://man.cx/gunzip(1)
[pdflatex(1)]: http://man.cx/pdflatex(1)
[openssl(1)]: http://man.cx/openssl(1)
[scp(1)]: http://man.cx/scp(1)
[ssh(1)]: http://man.cx/ssh(1)
[rsync(1)]: http://man.cx/rsync(1)
[autoreconf(1)]: http://man.cx/autoreconf(1)
[checkbashisms(1)]: http://man.cx/checkbashisms
[growlnotify(1)]: http://scottlab.ucsc.edu/Library/init/zsh/man/html/growlnotify.html
[sendmail(1)]: http://man.cx/sendmail(1)
[uuencode(1)]: http://man.cx/uuencode(1)
[epxand(1)]: http://man.cx/expand(1)
[unepxand(1)]: http://man.cx/unexpand(1)
[git(1)]: http://git-scm.com/
[ronn(1)]: https://github.com/rtomayko/ronn
[github(7)]: http://github.com/
[json-sh(1)]: https://github.com/dominictarr/JSON.sh
[npm(1)]: http://npmjs.org
[ruby(3)]: http://www.ruby-lang.org/
[rake(1)]: http://rake.rubyforge.org/
[semver(7)]: http://semver.org/
[ant(1)]: http://ant.apache.org/
[mvn(1)]: http://maven.apache.org/
[make(1)]: http://www.gnu.org/software/make/
[jsonlint(1)]: https://github.com/zaach/jsonlint
[jsoncheck(1)]: http://json.org/JSON_checker/
[ere(7)]: http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html
[couchdb(7)]: http://couchdb.apache.org/
[url(7)]: http://www.ietf.org/rfc/rfc1738.txt
[array-file(3)]: array-file.3.html
[array(3)]: array.3.html
[console(1)]: console.1.html
[console(3)]: console.3.html
[delegate(3)]: delegate.3.html
[executable(3)]: executable.3.html
[git(3)]: git.3.html
[globals(3)]: globals.3.html
[help(3)]: help.3.html
[json(3)]: json.3.html
[manual(1)]: manual.1.html
[prompt(1)]: prompt.1.html
[prompt(3)]: prompt.3.html
[semver(3)]: semver.3.html
[sprintf(3)]: sprintf.3.html
[strike-credits(7)]: strike-credits.7.html
[strike-tree(7)]: strike-tree.7.html
[strike(7)]: strike.7.html
[task-ant(7)]: task-ant.7.html
[task-archive(7)]: task-archive.7.html
[task-clean(7)]: task-clean.7.html
[task-compress(7)]: task-compress.7.html
[task-deploy-json(7)]: task-deploy-json.7.html
[task-deploy(7)]: task-deploy.7.html
[task-devel(7)]: task-devel.7.html
[task-doc(7)]: task-doc.7.html
[task-expand(7)]: task-expand.7.html
[task-latex(7)]: task-latex.7.html
[task-ls(7)]: task-ls.7.html
[task-make(7)]: task-make.7.html
[task-module(7)]: task-module.7.html
[task-mvn(7)]: task-mvn.7.html
[task-project(7)]: task-project.7.html
[task-rake(7)]: task-rake.7.html
[task-semver(7)]: task-semver.7.html
[task-test(7)]: task-test.7.html
[task-todo(7)]: task-todo.7.html
[version(3)]: version.3.html
