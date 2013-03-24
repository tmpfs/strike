array.each() {
  local name="${1:-}";
  local iterator="${2:-}";
  local key value;
  local index=0;
  if [ ! -z "$name" ]; then
    eval keys="\${!$name[@]}";
    echo "got array keys: ${keys}";
    for key in ${keys}
      do
        eval value="\${$name[$key]}";
        #echo "array.each got key : $key";
        echo "got value : $value";
        if method.exists? "$iterator"; then
          "$iterator" "$key" "$value" "$index" \
            || quit 1 "%s iterator error %s" "$FUNCNAME" "$iterator";
        fi
        : $((index++));
    done
  fi
}

#TODO: allow for spaces in associative array key names

# write array(s) to name=value pairs
array.write() {
  local opts=( "$@" );
  local file="${1:-}";
  local flags="${2:-g}";
  if [ -z "$file" ]; then
    console warn "no file passed to array.write";
  else
    echo -ne "" >| "$file" || quit 1 "could not create array.write file %s" "$file";
    local stdin;
    # this allows us to accept options and read from stdin
    # with positional parameter expansion
    if [ ! -t 0 ]; then
      # read in stdin
      read -a stdin;
      # expand stdin data to positional parameters
      set -- $( echo "${stdin[@]}" );
    fi

    iterator() {
      local key="$1" value="$2" index="$3";
      echo "${key}=${value}" >> "$file";
    }
    
    local arrflags isassoc;
    local i val;
    for((i = 0;i < $#;i++))
      do
        eval val="$"$[i+1];
        arrflags="-a";
        if array.is.assoc? "$val"; then
          arrflags="-A";
        fi
        arrflags="${arrflags}${flags}";
        # write the array name header comment
        echo "#¡ declare $arrflags $val" >> "$file";
        array.each "$val" "iterator";
    done

    # clean up the iterator
    method.remove "iterator";
  fi
}

# read a name=value pair array(s) file
array.read() {
  local opts=( "$@" );
  local file="${1:-}";
  local arrayname="";
  
  # deal with comments 
  array.read.comment() {
    if [[ "$1" =~ ^#¡ ]]; then
      local declaration=${1//#¡ /};
      local name=${declaration##* };
      # store the array name
      arrayname="$name";
      # declare the array
      eval "$declaration";
    fi
  }
  
  # add an entry to the current array being processed
  array.read.add() {
    local __key__=${1%%=*};
    local __value__=${1##*=};
    if [ ! -z "$arrayname" ]; then
      local setter="$arrayname[\"$__key__\"]=\"$__value__\";";
      eval "$setter";
    fi
  }
  
  if [ ! -z "$file" ] && [ -f "$file" ] && [ -r "$file" ]; then
    while read line
      do
        if [[ "$line" =~ ^# ]]; then
          array.read.comment "$line";
        else
          array.read.add "$line";
        fi
    done < "$file"
  elif [ ! -t 0 ]; then
    while read line
      do
        if [[ "$line" =~ ^# ]]; then
          array.read.comment "$line";
        else
          array.read.add "$line";
        fi
    done
  else
    quit 1 "invalid input to array.read, usage: array.read < file";
  fi
  
  # clean up the internal methods
  method.remove "array.read.comment";
  method.remove "array.read.add";
}
