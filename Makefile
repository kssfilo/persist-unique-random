.SUFFIXES:
#.SECONDARY:

NAME=persist-unique-random
BINNAME=unique-random
VERSION=0.1.2
DESCRIPTION=Unique Random Array Generator with Persist(saving to file) Feature + Command Line Tool
KEYWORDS=unique random array save persist save file command-line command line commandline tool cli 
NODEVER=8
LICENSE=MIT

PKGKEYWORDS=$(shell echo $$(echo $(KEYWORDS)|perl -ape '$$_=join("\",\"",@F)'))
PARTPIPETAGS="_=" "VERSION=$(VERSION)" "NAME=$(NAME)" "BINNAME=$(BINNAME)" "DESCRIPTION=$(DESCRIPTION)" 'KEYWORDS=$(PKGKEYWORDS)' "NODEVER=$(NODEVER)" "LICENSE=$(LICENSE)" 

#=

DESTDIR=dist
COFFEES=$(wildcard *.coffee)
TARGETNAMES=$(patsubst %.coffee,%.js,$(COFFEES))
TARGETS=$(patsubst %,$(DESTDIR)/%,$(TARGETNAMES))
DOCNAMES=LICENSE README.md package.json
DOCS=$(patsubst %,$(DESTDIR)/%,$(DOCNAMES))
ALL=$(TARGETS) $(DOCS)
SDK=node_modules/.gitignore
TOOLS=node_modules/.bin
SHELL=/bin/bash


#=

COMMANDS=build help pack test clean test-main

.PHONY:$(COMMANDS)

default:build

build:$(TARGETS)

docs:$(DOCS)

test:test.passed

test-main:$(TARGETS) test.bats 
	./test.bats

pack:$(ALL) test.passed |$(DESTDIR)

clean:
	-@rm -rf $(DESTDIR) package-lock.json test.passed node_modules 2>&1 >/dev/null ;true

configclean:
	-@rm -rf ~/.recipe-js/$(BINNAME).json

help:
	@echo "Targets:$(COMMANDS)"

#=

test.passed:test-main
	touch $@

$(DESTDIR):
	mkdir -p $@

$(DESTDIR)/%:% $(TARGETS) Makefile|$(SDK) $(DESTDIR)
	cat $<|$(TOOLS)/partpipe -c $(PARTPIPETAGS)  >$@

$(DESTDIR)/%.js:%.coffee $(SDK) |$(DESTDIR)
ifndef NC
	$(TOOLS)/coffee-jshint -o node $< 
endif
	head -n1 $<|grep '^#!'|sed 's/coffee/node/'  >$@ 
	cat $<|$(TOOLS)/partpipe $(PARTPIPETAGS) |$(TOOLS)/coffee -bcs >> $@
	chmod +x $@

$(SDK):package.json
	npm install
	@touch $@

