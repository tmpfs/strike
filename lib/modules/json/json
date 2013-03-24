require.library json.parse;
require.library json.stringify;

# cleans all global data set by
# json.parse and json.stringify
json.clean() {
  json.parse.clean;
}

# prints key/value pairs from the last call
# to json.parse
json.print() {
  local key val;
  for key in "${!json_doc[@]}"
    do
      val="${json_doc["$key"]}";
      console print -- "${key}=${val}";
  done
}
