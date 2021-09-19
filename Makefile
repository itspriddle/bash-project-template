DIRS=bin share
INSTALL_DIRS=`find $(DIRS) -type d`
INSTALL_FILES=`find $(DIRS) -type f`

PREFIX?=/usr/local

VERSION?=HEAD

test: test-shellcheck test-bats

test-shellcheck:
	shellcheck -f gcc -s bash bin/APP test/*.bats test/*.bash

test-bats: bats-setup
	./test/bats/bin/bats test

bats-setup:
	./test/setup

share/man/man1/APP.1: doc/man/APP.1.md
	kramdown-man doc/man/APP.1.md > share/man/man1/APP.1

install:
	for dir in $(INSTALL_DIRS); do mkdir -p $(DESTDIR)$(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(DESTDIR)$(PREFIX)/$$file; done

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(DESTDIR)$(PREFIX)/$$file; done

archive:
	mkdir -p pkg
	git archive --prefix=APP/ --output=pkg/APP-$(VERSION).zip $(VERSION) $(INSTALL_FILES)

.PHONY: bats-setup test test-shellcheck test-bats install uninstall archive