NAME     = "translate-shell"
COMMAND  = trans
BUILDDIR = build
MANDIR   = man

TARGET   = bash
PREFIX   = /usr/local

.PHONY: default clean build release grip test check install uninstall

default: build

clean:
	@gawk -f build.awk clean

build:
	@gawk -f build.awk build -target=$(TARGET)

release:
	@gawk -f build.awk build -target=$(TARGET) -type=release

grip:
	@gawk -f build.awk readme && grip

test: build
	@gawk -f test.awk

check: test
	$(BUILDDIR)/$(COMMAND) -V
	[ "`$(BUILDDIR)/$(COMMAND) -no-init -D -b 忍者`" = 'Ninja' ] &&\
	[ "`$(BUILDDIR)/$(COMMAND) -no-init -D -b 'hello world'`" = 'hello world' ]

install: build
	@mkdir -p $(PREFIX)/bin &&\
	install $(BUILDDIR)/$(COMMAND) $(PREFIX)/bin/$(COMMAND) &&\
	mkdir -p $(PREFIX)/share/man/man1 &&\
	cp $(MANDIR)/$(COMMAND).1 $(PREFIX)/share/man/man1/$(COMMAND).1 &&\
	echo "[OK] $(NAME) installed."

uninstall:
	@rm $(PREFIX)/bin/$(COMMAND) $(PREFIX)/share/man/man1/$(COMMAND).1 &&\
	echo "[OK] $(NAME) uninstalled."
