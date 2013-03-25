require.once opts/help;
help.man.page "ant" "task-ant.7";

taskinfo ant "Proxy to ant(1)";
tasks.ant() {
  executable.validate ant;  
  "${executables[ant]}" $@;
}
