#!/bin/bash

function prepare() {
    # check if sudo is used
    if [[ "$(id -u)" -ne 0 ]]; then
        echo "Script must be run under sudo from the user you want to install for. Try 'sudo \$0'"
        exit 1
    fi

    # ensure that all needed OS packages are installed
    apt-get install -y gpiod || (
        c=$?
        echo "Error during installation of APT packages"
        (exit $c)
    )

    # ensure that we are within the PowerBlock directory
    currentDirectory=${PWD##*/}
    if [[ $currentDirectory != "PowerBlock" ]]; then
        if [[ -d PowerBlock ]]; then
            rm -rf PowerBlock
        fi

        # Download and extract the repository
        curl -L https://github.com/petrockblog/PowerBlock/archive/master.tar.gz | tar xz
        mv PowerBlock-master PowerBlock
        cd PowerBlock || exit
    fi

    # ensure that no old instance of the driver is running
    isOldServiceRunning=$(pgrep -f powerblock)
    if [[ -n $isOldServiceRunning ]]; then
        source uninstall.sh
    fi
}

function installFiles() {
    install --mode 0755 scripts/powerblockservice /usr/bin/powerblockservice
    install --mode 0755 supplementary/powerblockconfig.cfg /etc/powerblockconfig.cfg
    install --mode 0755 supplementary/powerblockswitchoff.sh /etc/powerblockswitchoff.sh
}

function installService() {
    install -m 0755 scripts/powerblock /etc/init.d
    update-rc.d powerblock defaults
    /etc/init.d/powerblock start
    echo "Installation of PowerBlock service done."
}

function updateBootConfig() {
    FILE="$1" # Use the first argument as the file path
    LINE_TO_ENSURE="usb_max_current_enable=1"
    LINE_TO_REPLACE="usb_max_current_enable=0"

    # Check if the line exists and do nothing if it does
    if grep -Fxq "$LINE_TO_ENSURE" "$FILE"; then
        echo "$FILE is up-to-date, no action taken."
    elif grep -Fxq "$LINE_TO_REPLACE" "$FILE"; then
        # If the line with usb_max_current_enable=0 exists, replace it
        sed -i "s/^$LINE_TO_REPLACE/$LINE_TO_ENSURE/" "$FILE"
        echo "$FILE updated."
    else
        # If the line does not exist, append it
        echo "$LINE_TO_ENSURE" | sudo tee -a "$FILE"
        echo "$FILE updated."
    fi
}


# ----------------------------------

prepare
installFiles
installService

if [[ -f "/boot/config.txt" ]]; then
    updateBootConfig "/boot/config.txt"
elif [[ -f "/boot/firmware/config.txt" ]]; then
    updateBootConfig "/boot/firmware/config.txt"
fi

sleep 3

# sanity checks
# check that the binary is installed
if [[ ! -f /usr/bin/powerblockservice ]]; then
    echo "[ERROR] The PowerBlock driver executable is not installed"
else
    echo "[SUCCESS] The PowerBlock driver executable is installed"
fi

# check that the service is running
isServiceRunning=$(pgrep -f powerblock)
if [[ -n $isServiceRunning ]]; then
    echo "[SUCCESS] The PowerBlock service is running"
else
    echo "[ERROR] The PowerBlock service is not running"
fi

echo "You can find the configuration file at /etc/powerblockconfig.cfg".
