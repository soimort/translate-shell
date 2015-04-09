NAME     = "translate-shell"
COMMAND  = trans
BUILDDIR = build
MANDIR   = man

TARGET   = bash
PREFIX   = /usr/local

.PHONY: clean uninstall

default: build

clean:
	@gawk -f build.awk clean

$(COMMAND):
	@gawk -f build.awk build -target=$(TARGET)

build: $(COMMAND)

test: build
	[ "`$(BUILDDIR)/$(COMMAND) -b 忍者`" = 'Ninja' ]

install: build
	@install $(BUILDDIR)/$(COMMAND) $(PREFIX)/bin/$(COMMAND) &&\
	cp $(MANDIR)/$(COMMAND).1 $(PREFIX)/share/man/man1/$(COMMAND).1 &&\
	echo "[OK] $(NAME) installed."

uninstall:
	@rm $(PREFIX)/bin/$(COMMAND) $(PREFIX)/share/man/man1/$(COMMAND).1 &&\
	echo "[OK] $(NAME) uninstalled."
