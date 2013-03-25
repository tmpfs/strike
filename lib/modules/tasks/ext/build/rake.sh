require.once opts/help;
help.man.page "rake" "task-rake.7";

# wrapper for the rake executable
taskinfo rake "Proxy to rake(1)";
tasks.rake() {
  executable.validate rake; 
  "${executables[rake]}" $@;
}
