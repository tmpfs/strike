task-project(7) -- project task(s) for bake(1)
=============================================

## SYNOPSIS

Project task(s) for bake(1).

## DESCRIPTION

Maintains a list of related projects by unique identifier.

## REQUIRE

In your tasks(7) file `require` the `project` task(s) using:

	require 'tasks/project';

## USAGE

	bake project init
	bake project add [flags...] [id] [path|url] [url...]
	bake project exists [id]
	bake project ls
	bake project count
	bake project set [id] [name] [value]
	bake project get [id] [name]
	bake project del [id] [name...]
	bake project print [--pretty]
	bake project rm [id...]
	
## IDENTIFIERS

Project identifiers must be unique and must consist solely of the hyphen '-' and alphanumeric characters. They may not contain any other characters. These rules for project identifiers also apply to meta property names specified using the `set` command.
	
## COMMANDS

* `init`:

	Creates an empty projects file. This command will exit with >0 exit code if a projects file already exists.
	
* `add`:

	Add a project, the first option to this command is the unique identifier for the project the second option is either a relative or absolute file system path to the project or a remote URL. Subsequent options to `add` are related URLs for the project. Note that when specifying URLs they *should* be URL encoded so they do not contain any whitespace (or quoted or escaped correctly).
	
	This command will create a projects file if it does not exist and overwrite any existing *projects.json* file.
	
	If the path specified is a filesystem path then it must point to a valid directory.
	
* `set`:

	Set a meta data property for a project. Note that if multiple options are specified after the `name` option for the `value` then they are concatented into a single `value` using a space character as the delimiter. If the project property with the specified name exists it is overwritten.
	
	Attempting to set a property on a non-existent project will result in an error code >0.
	
* `get`:

	Get a meta data property for a project. If no property name is specified all meta data for the project is output. If no project identifier is specified then all project properties are listed.
	
	The output of this command is the project identifier than a space followed by the property name (a further space) and finally the property value.
	
* `del`:

	Deletes meta data properties for a project.
	
* `ls`:

	List projects. The output of this command is the identifier followed by the path (or URL) delimited by a space.
	
* `exists`:

	Determine whether a project with the specified identifier exists.
	
* `count`:

	Count the number of projects. The output of this command is an integer corresponding to the number of projects in the projects file.
	
* `print`:

	Print the raw JSON information.
	
* `rm`:

	Remove project(s) with the specified identifier(s).
	
	If any of the project identifiers do not exist this command will exit with a code >0 and no further project identifiers will be processed.
	
## FLAG OPTIONS

* `-f | --force`:

	Add a project by force even if a project with the same identifier already exists.
	
* `--pretty`:

	Use in conjunction with the `print` command to pretty print the JSON.
	
## FILES

The projects meta information is stored in a file named *projects.json* in the `${root}` of the current project.

## EXIT CODES

A >0 exit code indicates failure while a 0 exit code indicates success.

## BUGS

**task-project** is written in bash and depends upon `bash` >= 4.2.

## COPYRIGHT

**task-project** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

bake(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[REQUIRE]: #REQUIRE "REQUIRE"
[USAGE]: #USAGE "USAGE"
[IDENTIFIERS]: #IDENTIFIERS "IDENTIFIERS"
[COMMANDS]: #COMMANDS "COMMANDS"
[FLAG OPTIONS]: #FLAG-OPTIONS "FLAG OPTIONS"
[FILES]: #FILES "FILES"
[EXIT CODES]: #EXIT-CODES "EXIT CODES"
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
