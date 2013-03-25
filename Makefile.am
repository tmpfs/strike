AUTOMAKE_OPTIONS = foreign
EXTRA_DIST = bin lib doc test

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = strike.pc

man1_MANS = man/*.1
man3_MANS = man/*.3
man7_MANS = man/*.7


maindir = $(prefix)/strike
nobase_main_DATA = \
	version
mainbindir = $(maindir)/bin
mainbin_SCRIPTS = bin/*
librarydir = $(maindir)
nobase_library_DATA = \
	lib/*.sh \
	lib/modules/core/*.sh \
	lib/modules/json/*.sh \
	lib/modules/net/*.sh \
	lib/modules/opts/*.sh \
	lib/modules/tasks/*.sh \
	lib/modules/tasks/deploy/*.sh \
	lib/modules/tasks/ext/*.sh \
	lib/modules/tasks/ext/build/*.sh \
	lib/modules/util/*.sh \
	lib/modules/*.sh

all:
	@echo "install $(PACKAGE_NAME)@$(PACKAGE_VERSION) to $(prefix)";
	
install-exec-local:
	@:

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
