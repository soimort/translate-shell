install:
	sudo cp translate.awk /usr/bin/translate
	sudo ln -sf /usr/bin/translate /usr/bin/trs

uninstall:
	sudo rm /usr/bin/translate /usr/bin/trs
