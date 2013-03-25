AUTOMAKE_OPTIONS = foreign
EXTRA_DIST = bin doc lib LICENSE README.md test version

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = strike.pc

man1_MANS = doc/man/*.1
man3_MANS = doc/man/*.3
man7_MANS = doc/man/*.7

maindir = $(prefix)/strike
nobase_main_DATA = \
	version
mainbindir = $(maindir)/bin
mainbin_SCRIPTS = bin/*
librarydir = $(maindir)
nobase_library_DATA = \
	doc/man/* \
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

check-local:
	./bin/bake test

installcheck-local:
	$(mainbindir)/bake --version

test:
	./bake test
	
.PHONY: test
