install:
	@if [ `uname -s` = 'Linux' ]; \
	then sudo cp translate.awk /usr/bin/translate; \
	else sed 's/#!\/usr\/bin\/awk -f/#!\/usr\/bin\/env gawk -f/' translate.awk | sudo tee /usr/bin/translate >/dev/null; sudo chmod +x /usr/bin/translate; \
	fi \
	&& sudo ln -sf /usr/bin/translate /usr/bin/trs \
	&& echo "Successfully installed."

uninstall:
	@sudo rm /usr/bin/translate /usr/bin/trs \
	&& echo "Successfully uninstalled."
