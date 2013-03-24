# determine if the version of find(1)
# is GNU or BSD find
find.gnu?() {
  ( find -version > /dev/null 2>&1; );
  return $?;
}
