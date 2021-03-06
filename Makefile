WETTER_USER := $(shell whoami)

WETTER := ~$(WETTER_USER)/.local/bin/getWetter.sh
CLEANER := ~$(WETTER_USER)/.local/bin/clean_unsafe_shutdown
WETTER_SERVICE := ~$(WETTER_USER)/.config/systemd/user/getWetter@.service
WETTER_TIMER := ~$(WETTER_USER)/.config/systemd/user/getWetter.timer
WETTER_AUTOSTART := ~$(WETTER_USER)/.config/lxsession/LXDE-pi/autostart
WETTER_HTML := ~$(WETTER_USER)/.local/index.html

.PHONY: install update clean

install: update
	if which systemctl; then \
		systemctl --user -f enable --now getWetter.timer; \
	else \
		echo "Systemd not found, install service yourself and reboot for autostart"; \
	fi
	sudo apt-get install -y chromium-browser
	echo "\n #### Please reboot your system for the effect of the autostart script ####"; 

update:
	install -m 0755 -D getWetter.sh $(WETTER)
	install -m 0755 -D clean_unsafe_shutdown $(CLEANER)
	install -m 0644 index.html $(WETTER_HTML)
	install -m 0644 -D config/lxsession/LXDE-pi/autostart $(WETTER_AUTOSTART)
	if which systemctl; then \
		install -m 0644 -D config/systemd/user/getWetter@.service $(WETTER_SERVICE); \
		install -m 0644 -D config/systemd/user/getWetter.timer $(WETTER_TIMER); \
		sed -i s/$(WETTER_USER)/pi/g $(WETTER_SERVICE); \
		sed -i s/$(WETTER_USER)/pi/g $(WETTER_AUTOSTART); \
		systemctl --user daemon-reload; \
	fi

clean:
	if which systemctl; then \
		systemctl --user -f disable getWetter.timer; \
		rm -f $(WETTER_SERVICE); \
		rm -f $(WETTER_TIMER); \
	fi
	rm -f $(WETTER) $(WETTER_HTML) $(WETTER_AUTOSTART)
