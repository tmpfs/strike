AC_INIT([strike], m4_esyscmd([tr -d '\n' <version]), [bugs@xpm.io])
AM_INIT_AUTOMAKE([1.13 foreign silent-rules dist-bzip2 no-dependencies])
AC_CANONICAL_HOST
AC_PROG_AWK
AC_PROG_EGREP
AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MKDIR_P
PKG_PROG_PKG_CONFIG

# REQUIRED PROGRAMS

# check for bash
AC_PATH_PROG(BASH_CHECK,bash)
if test -z "$BASH_CHECK"; then
  AC_MSG_ERROR([bash not found, install from http://www.gnu.org/software/bash/])
fi

# check bash version
AM_CONDITIONAL([BASH_42], [./bin/bash-version 4 2 > /dev/null])
AM_COND_IF([BASH_42],
  [AC_MSG_RESULT(checking for bash >= 4.2... yes)],
  [AC_MSG_ERROR([bash >= 4.2 is required])])

# check for tput
AC_PATH_PROG(TPUT_CHECK,tput)
if test -z "$TPUT_CHECK"; then
  AC_MSG_ERROR([tput not found])
fi

# check for readlink
AC_PATH_PROG(READLINK_CHECK,readlink)
if test -z "$READLINK_CHECK"; then
  AC_MSG_ERROR([readlink not found])
fi

# check for tar
AC_PATH_PROG(TAR_CHECK,tar)
if test -z "$TAR_CHECK"; then
  AC_MSG_ERROR([tar not found])
fi

# check for gzip
AC_PATH_PROG(GZIP_CHECK,gzip)
if test -z "$GZIP_CHECK"; then
  AC_MSG_ERROR([gzip not found])
fi

# check for gunzip
AC_PATH_PROG(GUNZIP_CHECK,gunzip)
if test -z "$GUNZIP_CHECK"; then
  AC_MSG_ERROR([gunzip not found])
fi

# printf "checking for GNU find... \n";
# printf "checking for GNU tar... \n";

# OPTIONAL RECOMMENDED PROGRAMS

# check for curl
AC_PATH_PROG(CURL_CHECK,curl,yes)
if test -z "$CURL_CHECK"; then
  AC_MSG_WARN([curl is recommended, install from http://curl.haxx.se/download.html])
fi

AC_CONFIG_FILES([
  strike.pc
  Makefile
])

AC_OUTPUT
