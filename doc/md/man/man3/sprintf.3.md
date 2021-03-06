sprintf(3) -- tty printf
=============================================

## SYNOPSIS

	sprintf [options...] message [parameters...]

## DESCRIPTION

Print ANSI formatted output to a terminal.

If either stdout or stderr is not a *tty* then formatting of the output message is not performed which means that when redirecting to a file the ANSI sequence is omitted and the string is passed with parameter replacement performed but no formatting.

## OPTIONS

* `-1`:

Print to *stdout*.

* `-2`:

Print to *stderr*.

* `--color=[auto|always|never]`:

Determines when ANSI sequences are generated. The value *auto* is the default behaviour. Use *never* to never add ANSI sequences to a message and *always* to force adding ANSI sequences to a message even if the output is not a tty.

* `--text=[color]`:

Set *color* as the text color. See `COLOR NAMES`.

* `--background=[color]`:

Set *color* as the background color. See `COLOR NAMES`.

* `--attribute=[name]`:

Set *name* as the message attribute. See `ATTRIBUTE NAMES`.

* `--prefix=[prefix]`:

Prepend *prefix* to the message.

* `--suffix=[suffix]`:

Append *suffix* to the message.

* `--prefix-command=[command]`:

Execute *command* to generate the message prefix. The *command* has access to the `prefix` variable containing any current prefix and should set this variable to modify the message prefix.

* `--program`:

Prepend the program name to a message.

* `--date`:

Append a date to the message prefix.

* `--timestamp`:

Append a timestamp to the message prefix.

* `--export=[name]`:

Do not print the message assign to the variable *name*.

* `--no-prefix`:

Do not print the prefix.

* `--no-bright-prefix`:

Do not apply bright styling to the message prefix.

* `--readline`:

Use escape sequences compatible with passing to `read -ep`. This allows formatting to be applied to interactive prompts using `read`. When this option is used nothing is printed, you should use this option in conjunction with `--export` and pass the resulting variable as the prompt to `read -ep`.

* `--debug`:

Print debugging information.

## PARAMETER OPTIONS

ANSI sequences may be applied to individual parameters by using the parameter index in the range [0-9].

* `--text[n]=[color]`:

Set *color* as the text color for parameter *n*. See `COLOR NAMES`.

* `--background[n]=[color]`:

Set *color* as the background color for parameter *n*. See `COLOR NAMES`.

* `--attribute[n]=[name]`:

Set *name* as the attribute for parameter *n*. See `ATTRIBUTE NAMES`.

## HYPHENS

Use the `--` option to signal that option processing should stop so that message and replacement values that begin with a hyphen may be processed.

## COLOR NAMES

The available color names are:

* normal
* black
* red
* green
* brown
* blue
* magenta
* cyan
* gray

Each color is also available using a *bright* prefix:

* bright-black
* bright-red
* bright-green
* bright-brown
* bright-blue
* bright-magenta
* bright-cyan
* bright-gray

## ATTRIBUTE NAMES

The available attribute names are:

* normal
* bright
* faint (not widely supported)
* italic (not widely supported)
* underline
* blink
* negative
* positive

## TERMINAL EMULATORS

The `$TERM` variable must report one of the following values for ANSI replacement to be performed:

* xterm
* xterm-color
* vt100
* ansi
	
## ITERM2

It is recommended that users of iTerm2 uncheck the `Draw bold text in bright colors` option in `Profiles > Text` for highlighted replacement values to appear consistently with the main message colour.
	
## VARIABLES

The read only `ansi` associative array stores color names and ANSI escape sequence information.

## ENVIRONMENT

* `sprintf_color`:

If set to one of *auto*, *always* or *never* this variable overrides the behaviour of any `--color` option passed to sprintf(3).

## BUGS

**sprintf** is written in bash and depends upon `bash` >= 4.2.

## COPYRIGHT

**sprintf** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

console(3)

[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[OPTIONS]: #OPTIONS "OPTIONS"
[PARAMETER OPTIONS]: #PARAMETER-OPTIONS "PARAMETER OPTIONS"
[HYPHENS]: #HYPHENS "HYPHENS"
[COLOR NAMES]: #COLOR-NAMES "COLOR NAMES"
[ATTRIBUTE NAMES]: #ATTRIBUTE-NAMES "ATTRIBUTE NAMES"
[TERMINAL EMULATORS]: #TERMINAL-EMULATORS "TERMINAL EMULATORS"
[ITERM2]: #ITERM2 "ITERM2"
[VARIABLES]: #VARIABLES "VARIABLES"
[ENVIRONMENT]: #ENVIRONMENT "ENVIRONMENT"
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
