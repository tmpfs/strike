AUTOMAKE_OPTIONS = foreign
# SUBDIRS = lib
# bin_PROGRAMS = bake
# SUBDIRS = bin man lib test

# dist_data_DATA = lib man test

all:
	@echo "my all called ... ";
	
install-exec-local:
	@echo "install-exec-local ... $(prefix) : $(PACKAGE_NAME) $(PACKAGE_VERSION)";
	
install-data-local:
	@echo "install-data-local ... $(prefix)";
	
clean-local:
	@echo "clean-local ... ";
	
test:
	./bake test
	
.PHONY: test