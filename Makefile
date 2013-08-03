install:
	@if [ `uname -s` = 'Darwin' -o `uname -s` = 'FreeBSD' ]; \
	then sed 's/#!\/usr\/bin\/gawk -f/#!\/usr\/bin\/env gawk -f/' translate.awk | sudo tee /usr/bin/translate >/dev/null; sudo chmod +x /usr/bin/translate; \
	else sudo cp translate.awk /usr/bin/translate; \
	fi \
	&& sudo ln -sf /usr/bin/translate /usr/bin/trs \
	&& echo "Successfully installed."

uninstall:
	@sudo rm /usr/bin/translate /usr/bin/trs \
	&& echo "Successfully uninstalled."

test:
	[ `./translate 忍者` = 'Ninja' ]
	[ `./translate {zh=} 忍者` = 'Ninja' ]
	[ `./translate {=fr} 忍者` = 'Ninja' ]
	[ `./translate {ja=@ja} 忍者` = 'Ninja' ]
	[ `./translate {zh=ja} 忍者` = '忍者' ]
