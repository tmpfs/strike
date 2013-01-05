###############################################################################################
# strike http://freeformsystems.github.com/strike
#
# The MIT License (MIT)
# https://github.com/freeformsystems/strike/blob/master/LICENSE
# Copyright (c) 2012 muji <noop@xpm.io>
#
# Targets:
#
# make all: clean + test + doc + doc-push
#
# make clean: cleans the *target* directory
#
# make test: runs the unit tests
#
# make docs: generates the documentation into markdown, man pages and html documents
#
# make release version=x.x.x: make all, then sets version number using `semver write`
#
# make doc-push version=x.x.x: generates the web site with latest version and pushes to github
#
################################################################################################

#SRC := $(wildcard lib/**)

all: clean test doc doc-push
	
clean:
	./bake clean	
	
test:
	./bake test
	
doc:
	./bake doc.build
	
doc-push:
	./bake doc.pages.push
	
release: all
	ifndef version
		@echo "You must give a semver version to make release"
		@exit 2
	endif
	#./bake semver major $(VERSION)
	
.PHONY : clean test doc doc-push release