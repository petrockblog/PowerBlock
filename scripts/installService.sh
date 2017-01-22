#!/bin/bash

install -m 0755 powerblock /etc/init.d
update-rc.d powerblock defaults
/etc/init.d/powerblock start

