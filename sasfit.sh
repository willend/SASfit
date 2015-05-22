#!/bin/bash
# http://stackoverflow.com/a/630387
PATH="`dirname \"$0\"`"
UNAME="/bin/uname"
[ -f "$UNAME" ] || UNAME="/usr/bin/uname"
OS=$($UNAME -s)
if [ "$OS" == "Darwin" ]; then
  DYLD_LIBRARY_PATH="$PATH:$DYLD_LIBRARY_PATH" "$PATH"/sasfit
else
  LIBPATH="$PATH/lib"
  "$LIBPATH"/ld-[0-9].[0-9][0-9].so --library-path "$LIBPATH" "$PATH"/sasfit
fi;
