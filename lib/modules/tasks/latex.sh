# -draftmode              switch on draft mode (generates no output PDF)
# -enc                    enable encTeX extensions such as \mubyte
# -etex                   enable e-TeX extensions
# [-no]-file-line-error   disable/enable file:line:error style messages
# -fmt=FMTNAME            use FMTNAME instead of program name or a %& line
# -halt-on-error          stop processing at the first error
# -ini                    be pdfinitex, for dumping formats; this is implicitly
#                           true if the program name is `pdfinitex'
# -interaction=STRING     set interaction mode (STRING=batchmode/nonstopmode/
#                           scrollmode/errorstopmode)
# -ipc                    send DVI output to a socket as well as the usual
#                           output file
# -ipc-start              as -ipc, and also start the server at the other end
# -jobname=STRING         set the job name to STRING
# -kpathsea-debug=NUMBER  set path searching debugging flags according to
#                           the bits of NUMBER
# [-no]-mktex=FMT         disable/enable mktexFMT generation (FMT=tex/tfm/pk)
# -mltex                  enable MLTeX extensions such as \charsubdef
# -output-comment=STRING  use STRING for DVI file comment instead of date
#                           (no effect for PDF)
# -output-directory=DIR   use DIR as the directory to write files to
# -output-format=FORMAT   use FORMAT for job output; FORMAT is `dvi' or `pdf'
# [-no]-parse-first-line  disable/enable parsing of the first line of the
#                           input file
# -progname=STRING        set program (and fmt) name to STRING
# -recorder               enable filename recorder
# [-no]-shell-escape      disable/enable \write18{SHELL COMMAND}
# -shell-restricted       enable restricted \write18
# -src-specials           insert source specials into the DVI file
# -src-specials=WHERE     insert source specials in certain places of
#                           the DVI file. WHERE is a comma-separated value
#                           list: cr display hbox math par parend vbox
# -synctex=NUMBER         generate SyncTeX data for previewers if nonzero
# -translate-file=TCXNAME use the TCX file TCXNAME
# -8bit                   make all characters printable by default
# -help                   display this help and exit
# -version                output version information and exit
#

taskinfo latex "Compile latex source to pdf or dvi"
tasks.latex() {
  executable.validate pdflatex;
  
  # default directory used to search for files
  local latex_dir="./doc/latex";
  
  # default output format
  local latex_output_format="pdf";
  
  # options passed to pdflatex(1)
  local latex_options=();
  
  # list of source files
  local latex_files=();
  
  # the output directory for compilation
  local latex_output="";
  
  # whether we are debugging the commands
  # being executed
  local latex_debug=false;
  
  # do command procesing via delegation
  if [ $# -gt 0 ]; then
    local cmd="${1:-}";

    if [ "$cmd" == "pdf" ] || [ "$cmd" == "dvi" ]; then
      # remove the command option
      shift;
      latex_output_format="$cmd";
    fi
    
    # parse remaining options
    __latex.parse "$@";
    local opts=( $_result );
    __latex.defaults;
    delegate "ltx.${FUNCNAME}" "compile" "${opts[@]:-}";
  else
    __latex.defaults;
    ltx.tasks.latex.all;
  fi
}

function ltx.tasks.latex.compile {
  if [ -z "$1" ]; then
    shift;
  fi
  # just the output format specified
  # pass on to the all behaviour
  if [ $# -eq 0 ]; then
    ltx.tasks.latex.all;
  else
    __latex.compile;
  fi
}

# compile everything we find in doc/latex
# to ${target}
function ltx.tasks.latex.all {
  __latex.files.get;
  if [ ${#latex_files[@]} -eq 0 ]; then
    console quit 1 "no %s files in %s" ".tex" "$latex_dir";
  else
    __latex.compile.all;
  fi
}

######################################################################
#
# PRIVATE METHODS
#
######################################################################

# configures default options
function __latex.defaults {
  if [ -z "$latex_output" ]; then
    latex_output="${target}/$latex_output_format";
  fi
  if [ ! -d "$latex_output" ]; then
    mkdir -p "$latex_output" || quit 1 "could not create latex output directory %s" "$latex_output";
  fi
  
  # always expand path so that nested directory
  # structure are correct when using the ./doc/latex path
  if [ -d "$latex_output" ]; then
    fs.path.expand "$latex_output";
    latex_output="$_result";
  fi
  
  #  -output-directory should always be index 0
  latex_options+=( "-output-directory=$latex_output" );
  
  latex_options+=( "-output-format=$latex_output_format" );
  latex_options+=( "-halt-on-error" );
  
  # TODO: add custom latex options here
}

function __latex.files.get {
  local dir="${1:-$latex_dir}";
  if [ -d "$dir" ]; then
    latex_files+=( $( find "$dir" -name *.tex ) );
  fi
}

# attempts to compile multiple .tex files
function __latex.compile.all {
  local file;
  for file in "${latex_files[@]}"
    do
      __latex.compile "$file";
  done
}

# attempts to compile a single .tex source file
function __latex.compile {
  local name nm parent target output="$latex_output";
  fs.basename "$file" "name";
  nm="${name%.tex}";
  
  fs.dirname "$file" "parent";
  # target used to cd into so that external files
  # are resolved relative to the source .tex file
  target="${parent}";
  # make parent realtive to latex_dir
  parent="${parent#$latex_dir}";

  # echo "compiling with dir: $latex_dir";
  # echo "compiling with file: $file";
  # echo "compiling with parent: $parent";
  
  # if parent is empty the output is the root
  if [ -n "$parent" ]; then
    output="${output}${parent}";
    
    if [ ! -d "$output" ]; then
      mkdir -p "$output" || console quit 1 "could not create output directory %s" "$output";
    fi
  fi
  
  latex_options[0]="-output-directory=$output";
  
  # echo "using output: $output";
  
  if $latex_debug; then
    console print "${executables[pdflatex]} ${latex_options[*]} %s" "$file";
  fi

  local logfile="${output}/${nm}.compile.log";
  
  # exit code from compilation
  local owd=$( pwd );
  # run in subshell so the `cd` does no affect working
  # directory of the parent shell
  cd "${target}" || console quit 1 "could not cd to %s" "${target}";
  # TODO: quote options passed to latex to allow spaces in file paths
  "${executables[pdflatex]}" "${latex_options[@]:-}" "$file" >| "$logfile" 2>&1;
  if [ $? -gt 0 ]; then
    if $latex_debug; then
      if [ -f "${output}/${nm}.log" ]; then
        # latex generated log file, more verbose/informative
        cat "${output}/${nm}.log" >&2;
      else
        cat "$logfile" >&2;
      fi
    fi
    console warn "log file %s" "${output}/${nm}.log";
    console warn "log file %s" "$logfile";
    console quit 1 "failed to compile %s" "$file";
  fi
  cd "$owd" || console quit 1 "could not cd to %s" "${owd}";
}

# parse command line options
function __latex.parse {
  # unprocessed options
  local options=();
  
  # listing the pdflatex options
  # allows us to add our own options
  # and validate the options parsed before
  # invoking pdflatex, will need a resync
  # when new versions of pdflatex are released
  # the boolean value indicates whether the pdflatex
  # option expects a value using the = operator
  declare -A latex_options=(
    [-draftmode]=false
    [-enc]=false
    [-etex]=false
    [file-line-error]=false
    [-no-file-line-error]=false
    [-fmt]=true
    [-ini]=false
    [-interaction]=true
    [-ipc]=false
    [-ipc-start]=false
    [-jobname]=true
    [-kpathsea-debug]=true
    [mktex]=true
    [-no-mktex]=true    
    [-mltex]=false
    [-output-comment]=true
    [-no-parse-first-line]=false
    [-progname]=true
    [-recorder]=false
    [-shell-escape]=false
    [-no-shell-escape]=false
    [-shell-restricted]=false
    [-src-specials]=false
    [-src-specials]=true
    [-synctex]=true
    [-translate-file]=true
    [-8bit]=false
  );

  # unsupported pdflatex(1) options
  
  # [-output-directory]=true
  # [-output-format]=true
  # [-halt-on-error]=false
  # -help
  # -version
  
  local value;
  # handle other options
  while [ "${1:-}" != "" ]; do
    case $1 in
      -d | --dir )
        shift;
        value="${1:-}";
        if [ -z "$value" ]; then
          console quit 1 "no directory specified for the %s option" "-d | --dir";
        fi
        if [ ! -d "$value" ]; then
          console quit 1 "%s not a directory" "$value";
        fi
        if [ ! -r "$value" ]; then
          console quit 1 "%s not readable" "$value";
        fi
        latex_dir="$value";
        ;;
      -o | --output )
        shift;
        value="${1:-}";
        if [ -z "$value" ]; then
          console quit 1 "no directory specified for the %s option" "-o | --output";
        fi
        if [ ! -d "$value" ] || [ ! -w "$value" ]; then
          console quit 1 "invalid output directory %s" "$value";
        fi
        # remove any trailing slash
        value="${value%/}";
        latex_output="$value";
        ;;
      --debug )
        latex_debug=true;
        ;;          
      * )
        options+=( "$1" );
        ;;
    esac
    if [ $# -ne 0 ]; then
      shift;
    else
      break;
    fi
  done

  # return remaining options back
  _result="${options[@]:-}";
}
