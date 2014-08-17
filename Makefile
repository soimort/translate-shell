NAME     = "Translate Shell"
COMMAND  = trans
BUILDDIR = build
MANDIR   = man

TARGET   = bash
INSTDIR  = /usr/bin

.PHONY: clean uninstall

default: build

clean:
	@gawk -f build.awk clean

$(COMMAND):
	@gawk -f build.awk build -target=$(TARGET)

build: $(COMMAND)

test: build
	[ `$(BUILDDIR)/$(COMMAND) -b 忍者` = 'Ninja' ]

install: build
	@install $(BUILDDIR)/$(COMMAND) $(INSTDIR)/$(COMMAND) && echo "[$(NAME)] Successfully installed."

uninstall:
	@rm $(INSTDIR)/$(COMMAND) && echo "[$(NAME)] Successfully uninstalled."
