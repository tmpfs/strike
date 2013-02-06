AC_INIT([strike], [0.1.9], [bugs@xpm.io])
AM_INIT_AUTOMAKE([-Wall -Werror foreign])
AC_CONFIG_FILES([Makefile])
AC_PROG_AWK
AC_PROG_EGREP
#AC_PROG_CXX
AC_PROG_INSTALL
AC_PROG_LN_S
AC_PROG_MKDIR_P

printf "checking bash version >= 4.2... \n";

# check for curl
AC_PATH_PROG(CURL_CHECK,curl,yes)
if test -z "$CURL_CHECK"; then
    AC_MSG_ERROR([curl not found, install from http://curl.haxx.se/download.html])
fi

# if test x"$CURL_CHECK" != x"yes" ; then
#     AC_MSG_ERROR([Please install curl before installing.])
# fi

# check for curl
# AC_CHECK_PROG(CURL_CHECK,curl,yes)
# if test x"$CURL_CHECK" != x"yes" ; then
#     AC_MSG_ERROR([Please install curl before installing.])
# fi

# printf "checking for GNU find... \n";
# printf "checking for GNU tar... \n";

AC_OUTPUT
