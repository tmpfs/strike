require.once opts/help;
help.man.page "make" "task-make.7";

taskinfo make "Proxy to make(1)";
tasks.make() {
  executable.validate make; 
  "${executables[make]}" $@;
}
