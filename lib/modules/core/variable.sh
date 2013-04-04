# regular expression used to sanitize dynamic
# variables names
declare -g variable_name_sanitize_regexp="[^a-zA-Z0-9_]";

variable.get() {
  local name="$1";
  local assign="${2:-value}";
  set +o nounset;
  #array.is.array? "$name";
  #local isarray="$_result";
  if array.is.array?; then
    eval value=\${"$name"[@]};
  else
    eval "${assign}=\${$name}";
  fi
  _result="$value";
  set -o nounset;
}

variable.set() {
  local name="$1";
  local value="$2";
  local declaration="${3:-}";
  # add space delimiter
  if [ -n "${declaration}" ]; then
    declaration="${declaration} ";
  fi
  #echo "variable.set: $name : $value";
  eval "${declaration}${name}"="'${value}'";
  #variable.get "$name";
  #echo "$_result";
}

# determine if a variable has been set
# variable.isset?() {
#   eval '[ ${'$1'+a} ]';
# }

#            | unset |   set    | set and  | meaning
#             |       | but null | not null |
# ============+=======+==========+==========+=============================
#  ${var-_}   |   T   |     F    |    T     | not null or not set
# ------------+-------+----------+----------+-----------------------------
#  ${var:-_}  |   T   |     T    |    T     | always true, use for subst.
# ------------+-------+----------+----------+-----------------------------
#  $var       |   F   |     F    |    T     | var is set and not null
# ------------+-------+----------+----------+-----------------------------
#  ${!var[@]} |   F   |     T    |    T     | var is set
