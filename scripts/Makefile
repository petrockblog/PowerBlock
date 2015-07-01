installservice:
	install -m 0755 powerblock /etc/init.d
	update-rc.d powerblock defaults
	/etc/init.d/powerblock start

uninstallservice:
	/etc/init.d/powerblock stop
	update-rc.d powerblock remove
	-rm /etc/init.d/powerblock
