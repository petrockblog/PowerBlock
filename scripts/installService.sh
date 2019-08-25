#!/bin/bash

apt-get -Y install device-tree-compiler
dtc -@ -I dts -O dtb -o gpio_pull-overlay.dtb gpio_pull-overlay.dts
cp gpio_pull-overlay.dtb /boot/overlays
grep -qxF 'dtoverlay=gpio_pull' /boot/config.txt || echo 'dtoverlay=gpio_pull' >> /boot/config.txt

install -m 0755 powerblock /etc/init.d
update-rc.d powerblock defaults
/etc/init.d/powerblock start

