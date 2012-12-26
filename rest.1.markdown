rest(1) -- Generate HTTP requests
=============================================

## SYNOPSIS

`rest` command [<var>options</var>...] <var>url</var><br>

## DESCRIPTION

**rest** generates HTTP requests using the http(1) module which wraps curl(1). The core commands correspond to the HTTP verbs GET, POST, PUT, HEAD, DELETE and OPTIONS.

## FILES

The http(1) module generates some temporary files and some files used for logging purposes.

## OPTIONS

Wherever possible **rest** follows the command line options available to curl(1) but also adds some convenient shortcut options.

* `--type`:
	Set the content type for the request.
* `-H`, `--header`:
	Set a request header.

## BUGS

**rest** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**rest** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

curl(1)

[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[FILES]: #FILES "FILES"
[OPTIONS]: #OPTIONS "OPTIONS"
[BUGS]: #BUGS "BUGS"
[COPYRIGHT]: #COPYRIGHT "COPYRIGHT"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[bake(1)]: 	bake.1.html
[http(1)]: 	http.1.html
[rest(1)]: 	rest.1.html
[curl(1)]: 	http://man.cx/curl(1).html
[manpages(5)]: 	http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man5/manpages.5.html.html
[http(1)]: http.1.html
[rest(1)]: rest.1.html
