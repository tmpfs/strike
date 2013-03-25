# # methods for lowercasing
# 
# $ echo $a | tr '[A-Z]' '[a-z]'
# hi all
# awk
# 
# $ echo $a | awk '{print tolower($0)}'
# hi all
# 
# bash 4.0
# 
# $ echo ${a,,}
# hi all
# Perl
# 
# $ echo $a|perl -e 'print lc <>;'
# hi all
# Bash
# 
# lc(){
#     case "$1" in
#         [A-Z])
#         n=$(printf "%d" "'$1")
#         n=$((n+32))
#         printf \\$(printf "%o" $n)
#     esac
# }
# word="ABX"
# for((i=0;i<${#word};i++))
# do
#     ch=${word:$i:1}
#     lc $ch
# done

# ${string^}    Hello, World! # First character to uppercase
# ${string^^}   HELLO, WORLD! # All characters to uppercase
# ${string,}    hello, World! # First character to lowercase
# ${string,,}   hello, world! # All characters to lowercase


string.split() {
  _result="";
  local array i;
  local IFS="${1:-}";
  # split on empty delimiter
  if [ -z "$IFS" ]; then
    if [ $# -gt 1 ]; then
      array=();
      for((i = 0;i < ${#2};i++))
        do
          array+=( "${2:$i:1}" );
      done
      if [ ${#array[@]} -gt 0 ]; then
        _result="${array[@]}";
      fi
    fi
  # split on delimiter
  else
    # TODO: use an inner callback for scoping issues
    return 0;
    # local join="${3:-}";
    #     echo "join $2 on $join";
    #     local IFS="${1:-}";
    #     echo "IFS '$IFS'";
    #     set ${2};
    #     echo "split on $@ : $#";
    #     _result="$@";   
    #     if [ -n "$join" ]; then
    #       local opt;
    #       local str quoted=();
    #       echo "got join opts : $@ : $#";
    #       for((i = 0;i < $#;i++))
    #         do
    #           opt="${$i}";
    #           echo "quoting for join: $opt : $str";         
    #           str=$( printf %q "$opt" );
    #           quoted+=( "$str" );
    #       done
    #       array.join "$join" ${quoted[@]};
    #     fi
  fi
  unset IFS;
}

string.quote() {
  _result=$( printf %q "$1" );
}

string.contains?() {
  local haystack="${1:-}";
  local needle="${2:-}";
  if [[ "$haystack" == *$needle* ]]; then
    return 0;
  fi
  return 1;
}

string.upper() {
  local str="${1:-}";
  _result="${str^^}";
}

string.repeat() {
  local repeated="";
  local str="${1:-}";
  declare -i end="${2:-1}";
  local varname="${3:-}";
  declare -i start="${4:-1}";
  if [ -n "${str}" ] && [ ${end} -gt 0 ]; then
    local seq=$(eval echo {${start}..${end}});
    repeated=$( printf "${str}%.0s" $seq );
    if [ -n "${varname}" ]; then
      variable.set "${varname}" "${repeated}";
      return 0;
    fi
  fi
  # DEPRECATED
  _result="${repeated}";
}

string.ltrim() {
  local value="${@}";
  read  -rd '' value <<< "$value";
  _result="$value";
}