require.once opts/help;
help.man.page "mvn" "task-mvn.7";

taskinfo mvn "Proxy to mvn(1)";
tasks.mvn() {
  executable.validate mvn;  
  "${executables[mvn]}" $@;
}
