task-compress(7) -- compress task(s) for bake(1)
=============================================

## SYNOPSIS

Compression task(s) for bake(1).

## DESCRIPTION

Deflate and inflate file(s) using gzip(1) and gunzip(1). This task is used to compress regular files, if you wish to compress directories use task-archive(7). The primary difference between gzip(1) and task-compress(7) is that source files or compressed files are maintained on disc by default. This is useful for web applications that wish to inspect an *Accept-Encoding* header and serve the appropriate file.

## REQUIRE

In your tasks(7) file `require` the `compress` task(s) using:

	require tasks/compress;

## USAGE

	bake compress -c [options...] [files...]
	bake compress -x [options...] [files...]
	
## COMMANDS

* `-c | create`:

	Deflate file(s). This command creates a file with the same name as the source file appended with a `gz` file extension. By default the original file is maintained, if you wish to delete the file(s) use the `--delete` option.
	
* `-x | extract`:

	Inflate compressed file(s).
	
## OPTIONS

* `-o | --output [directory]`:

	An existing writable directory to place files in. When use in conjunction with the `create` command then the deflated files will be placed in this directory. When used in conjunction with the `extract` command then the inflated files will be placed in this directory. By default when this option is used the output is a flat structure, which means that if multiple files with the same name exist in the list of files being processed then the last one processed will overwrite any previously created file.
	
* `-d | --dir [directory]`:

	The absolute path to the root directory where files are being resolved from. Use in conjunction with the `--output` and `--recursive` option so that files may be created with a directory structure that matches the source directory structure.
	
* `-i | --include [pattern]`:

	Pattern(s) that a file name must match to be included. Must be a valid extended regular expression, see ere(7). Repeatable. An exit code of 2 is used if a pattern is invalid.
	
* `-e | --exclude [pattern]`:

	Pattern(s) that when matched against a file name will cause it to be excluded. Must be a valid extended regular expression, see ere(7). Repeatable. If include and exclude pattern(s) are specified that both match a file name the file will be excluded. An exit code of 2 is used if a pattern is invalid.
	
## FLAG OPTIONS
	
* `-r | --recursive`:

	Recurse into sub-directories. When this option is not specified and a directory is passed as a file then the contents of that directory are included in the list of files used for compression or extraction, but no sub-directories will be searched. Specify this option if you also wish to search sub-directories for files to deflate/inflate.
	
* `-v | --verbose`:

	Output more information. When used in conjunction with the `create` and `extract` commands then this option will also include compression ratio information. When specified in conjunction with the `--noop` option the file size will be output after the file path.
	
* `--delete`:

	The default behaviour is to keep the source files, specify this flag if you wish to delete the source files. This mimics the default behaviour of gzip(1) and gunzip(1) whereby source files are deleted when deflating and compressed files are deleted when inflating.
	
* `--noop`:

	Do not perform any action, print information about the source and/or compressed files. The `--debug` option has no effect when this option is specified.
	
* `--debug`:

	Print the commands being executed. This option has no effect when the `--noop` option is specified.
	
## STDIN

You may use the '-' convention to specify that the file list should be read from stdin. For example to compress all the files in the current directory:

	find . -depth 1 -type f | bake compress -c -;
	
In addition, you can combine reading a file list from stdin with files specified after the '-', for example to compress all files with a .css file extension in the ./css directory and a file named README in the current working directory:

	find ./css -depth 1 -name *.css | bake compress -c - README;
	
## NOTES	

Any files specified that *do not exist* are skipped from processing and a warning is printed.

When the `create` command is executed files that end in the `.gz` file extension are automatically ignored.
	
## EXIT CODES

A >0 exit code indicates failure while a 0 exit code indicates success.

If any file is encountered that is not a regular file (determined using the -f file test operator) then the exit code is >0.

If an invalid pattern is specified using either the --include or --exclude option then an exit code of 2 is used.

## BUGS

**task-compress** is written in bash and depends upon `bash` >= 4.2.

## COPYRIGHT

**task-compress** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

bake(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[REQUIRE]: #REQUIRE "REQUIRE"
[USAGE]: #USAGE "USAGE"
[COMMANDS]: #COMMANDS "COMMANDS"
[OPTIONS]: #OPTIONS "OPTIONS"
[FLAG OPTIONS]: #FLAG-OPTIONS "FLAG OPTIONS"
[STDIN]: #STDIN "STDIN"
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
