AUTOMAKE_OPTIONS = foreign
# SUBDIRS = lib
# SUBDIRS = bin man lib test

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = strike.pc

# dist_data_DATA = lib man test
#

#bin_PROGRAMS = bin/bake
man1_MANS = man/*.1
man3_MANS = man/*.3
man7_MANS = man/*.7
# all:
# 	@echo "my all called : foo is $(foo)";
	
# install-exec-local:
#	@echo "install-exec-local ... $(prefix) : $(PACKAGE_NAME) $(PACKAGE_VERSION)";
	
# install-data-local:
#	@echo "install-data-local ... $(prefix) : foo is $(foo)";
	
# clean-local:
#	@echo "clean-local ... ";
	
test:
	./bake test
	
.PHONY: test
