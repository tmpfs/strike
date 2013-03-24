AUTOMAKE_OPTIONS = foreign
EXTRA_DIST = bin lib doc test

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = strike.pc

man1_MANS = man/*.1
man3_MANS = man/*.3
man7_MANS = man/*.7

bin_SCRIPTS = bin/*
librarydir = $(pkgdatadir)
nobase_library_DATA = \
	lib/*.sh \
	lib/modules/core/* \
	lib/modules/json/*

# all:
# 	@echo "my all called : foo is $(foo)";
	
# install-exec-local:
#	@echo "install-exec-local ... $(prefix) : $(PACKAGE_NAME) $(PACKAGE_VERSION)";
#
	
# install-data-local:
# install bin/bake $(bindir);
# install -d lib/** $(libdir);
#	@echo "install-data-local ... $(prefix) : foo is $(foo)";
	
# clean-local:
#	@echo "clean-local ... ";
	
test:
	./bake test
	
.PHONY: test
