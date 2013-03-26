AUTOMAKE_OPTIONS = foreign
EXTRA_DIST = bin doc INSTALL.md lib LICENSE README.md tasks test version
pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = strike.pc

man1_MANS = doc/man/*.1
man3_MANS = doc/man/*.3
man7_MANS = doc/man/*.7

maindir = $(prefix)/strike
nobase_main_DATA = \
	tasks \
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
	@echo "install $(PACKAGE_NAME)@$(PACKAGE_VERSION) to $(prefix)"
	
install-exec-local:
	@:

install-data-hook:
	@mkdir -p $(bindir)
	@ln -sf $(mainbindir)/bake $(bindir)/bake
	@$(INSTALL) $(mainbindir)/boilerplate.sh $(bindir)/boilerplate.sh
	@$(mainbindir)/bake boilerplate
	@$(mainbindir)/console --prefix="[ok]" "installation complete"

check-local:
	@./bin/bake test

installcheck-local:
	@command -v boilerplate.sh > /dev/null || exit 1;
	@$(mainbindir)/bake --version || exit 1;
	@$(mainbindir)/console --prefix="[ok]" "installation check ok";

uninstall-local:
	@echo "uninstall $(PACKAGE_NAME)@$(PACKAGE_VERSION) from $(prefix)"
	@rm -rfv "$(maindir)"
	@rm "$(bindir)/bake"
	@rm "$(bindir)/boilerplate.sh"

test:
	@./bake test
	
.PHONY: test
