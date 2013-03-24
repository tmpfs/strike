AC_INIT([strike], [0.1.39], [bugs@xpm.io])
AM_INIT_AUTOMAKE([1.10 foreign])
AC_PROG_AWK
AC_PROG_EGREP
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MKDIR_P

#bin_PROGRAMS = bin/bake
#man1_MANS = man/bake.1

#EXTRA_DIST = lib LICENSE README.md

#pkgconfigdir = $(libdir)/pkgconfig
#pkgconfig_DATA = strike.pc

# check for curl
AC_PATH_PROG(BASH_CHECK,bash,yes)
if test -z "$BASH_CHECK"; then
  AC_MSG_ERROR([bash not found, install from http://www.gnu.org/software/bash/])
fi

printf "checking bash version >= 4.2... \n";

# check for curl
AC_PATH_PROG(CURL_CHECK,curl,yes)
if test -z "$CURL_CHECK"; then
  AC_MSG_ERROR([curl not found, install from http://curl.haxx.se/download.html])
fi


# printf "checking for GNU find... \n";
# printf "checking for GNU tar... \n";


AC_CONFIG_FILES([
  strike.pc
  Makefile
])

AC_OUTPUT
