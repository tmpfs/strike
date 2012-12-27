boilerplate(1) -- boilerplate for strike(1)
=============================================

## SYNOPSIS

Before using the strike(1) modules and functions you need to include some boilerplate code which is responsible for determining the filesystem path to the executable (including resolving symbolic links).

## BOILERPLATE

If you have installed the `strike` library as a node module and your executable is in a `bin` directory (sibling of the `node_modules` directory) the boilerplate would look like:

	declare -gx exedir;
	function boilerplate {
		local abspath=$(cd ${BASH_SOURCE[0]%/*} && echo $PWD/${0##*/});
		if [ -L "$abspath" ]; then
			abspath=`readlink $abspath`;
		fi
		exedir=`dirname "$abspath"`;
		local libdir="$exedir/../node_modules/strike/lib";
		source "$libdir/shared";
	}
	boilerplate;

## BUGS

**boilerplate** is written in bash and depends upon `bash` >= 4.

## COPYRIGHT

**boilerplate** is copyright (c) 2012 muji <http://xpm.io>

## SEE ALSO

strike(1)

[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[BOILERPLATE]: #BOILERPLATE "BOILERPLATE"
[BUGS]: #BUGS "BUGS"
[COPYRIGHT]: #COPYRIGHT "COPYRIGHT"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[strike(1)]: 	strike.1.html
[boilerplate(1)]: boilerplate.1.html
[method(1)]: 	method.1.html
[http(1)]: 	http.1.html
[bake(1)]: 	bake.1.html
[rest(1)]: 	rest.1.html
[curl(1)]: 	http://man.cx/curl(1).html
[manpages(5)]: 	http://developer.apple.com/mac/library/documentation/Darwin/Reference/ManPages/man5/manpages.5.html.html
[bake(1)]: bake.1.html
[http(1)]: http.1.html
[rest(1)]: rest.1.html
[strike(1)]: strike.1.html
