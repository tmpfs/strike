AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS = -I m4
EXTRA_DIST = bin doc INSTALL.md lib LICENSE README.md tasks test version
TESTS_ENVIRONMENT = cd $(srcdir) &&
pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = $(PACKAGE_NAME).pc

man1_MANS = $(srcdir)/doc/man/man1/*.1
man3_MANS = $(srcdir)/doc/man/man3/*.3
man7_MANS = $(srcdir)/doc/man/man7/*.7

maindir = $(prefix)/$(PACKAGE_NAME)
nobase_main_DATA = \
	$(srcdir)/tasks \
	$(srcdir)/version
mainbindir = $(maindir)/bin
mainbin_SCRIPTS = $(srcdir)/bin/*
librarydir = $(maindir)
nobase_library_DATA = \
	$(srcdir)/doc/man/* \
	$(srcdir)/lib/*.sh \
	$(srcdir)/lib/modules/core/*.sh \
	$(srcdir)/lib/modules/json/*.sh \
	$(srcdir)/lib/modules/net/*.sh \
	$(srcdir)/lib/modules/opts/*.sh \
	$(srcdir)/lib/modules/tasks/*.sh \
	$(srcdir)/lib/modules/tasks/deploy/*.sh \
	$(srcdir)/lib/modules/tasks/ext/*.sh \
	$(srcdir)/lib/modules/tasks/ext/build/*.sh \
	$(srcdir)/lib/modules/util/*.sh \
	$(srcdir)/lib/modules/*.sh

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
	@$(srcdir)/bin/bake test

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
	@$(srcdir)/bin/bake test
	
.PHONY: test
