#!/bin/bash

# check, if sudo is used
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Script must be run under sudo from the user you want to install for. Try 'sudo $0'"
    exit 1
fi

function uninstallFiles() {
    rm /usr/bin/powerblockservice
    rm /etc/powerblockconfig.cfg
    rm /etc/powerblockswitchoff.sh
}

function uninstallService() {
    update-rc.d powerblock remove
    rm /etc/init.d/powerblock
    echo "PowerBlock service uninstalled."
}

uninstallService
uninstallFiles

# check that the service is not running anymore
ps -ef | grep powerblock | grep -v grep
[ $?  -eq "0" ] && echo "[ERROR] Could not remove the PowerBlock service" || echo "[SUCCESS] The PowerBlock service was successfully removed."

