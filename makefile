###############################################################################################
# strike http://freeformsystems.github.com/strike
#
# The MIT License (MIT)
# Copyright (c) 2012 muji <noop@xpm.io>
#
# Targets:
#
# make clean: removes the target directory
#
# make test: run the unit tests
#
# make doc: generates the documentation as markdown, man pages and html documents
#
################################################################################################

#all: clean test docs doc-push

clean:
	./bake clean
	
test:
	./bake test
	
doc:
	./bake doc.build
	
json-checker:
	./bake json.checker.compile
	
.PHONY: clean test doc json-checker