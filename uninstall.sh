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
    # Stop the running service before removing it.
    if [ -x /etc/init.d/powerblock ]; then
        /etc/init.d/powerblock stop || true
    fi

    # Make sure no service process is left behind (e.g. when the PID file is stale).
    pkill -f "/usr/bin/powerblockservice" 2>/dev/null || true

    # gpiod v2's gpioset holds the status line until the process exits. Older
    # versions did not terminate it on shutdown, so release it here. Otherwise a
    # freshly installed service cannot claim the line again ("Device or resource busy").
    STATUS_PIN=$(sed -n 's/^statuspin=//p' /etc/powerblockconfig.cfg 2>/dev/null | head -1)
    STATUS_PIN=${STATUS_PIN:-17}
    pkill -f "gpioset.*${STATUS_PIN}=1" 2>/dev/null || true

    update-rc.d powerblock remove
    rm -f /etc/init.d/powerblock
    echo "PowerBlock service uninstalled."
}

uninstallService
uninstallFiles

# check that the service is not running anymore
echo "[SUCCESS] The PowerBlock service was successfully removed. Please reboot to finish the uninstallation."
