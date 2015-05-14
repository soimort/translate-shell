NAME     = "translate-shell"
COMMAND  = trans
BUILDDIR = build
MANDIR   = man

TARGET   = bash
PREFIX   = /usr/local

.PHONY: default clean build release test check install uninstall

default: build

clean:
	@gawk -f build.awk clean

build:
	@gawk -f build.awk build -target=$(TARGET)

release:
	@gawk -f build.awk build -target=$(TARGET) -type=release

test: build
	@gawk -f test.awk

check: test
	$(BUILDDIR)/$(COMMAND) -V
	[ "`$(BUILDDIR)/$(COMMAND) -b 忍者`" = 'Ninja' ]

install:
	@install $(BUILDDIR)/$(COMMAND) $(PREFIX)/bin/$(COMMAND) &&\
	cp $(MANDIR)/$(COMMAND).1 $(PREFIX)/share/man/man1/$(COMMAND).1 &&\
	echo "[OK] $(NAME) installed."

uninstall:
	@rm $(PREFIX)/bin/$(COMMAND) $(PREFIX)/share/man/man1/$(COMMAND).1 &&\
	echo "[OK] $(NAME) uninstalled."
