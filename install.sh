#!/bin/bash

function prepare() {
    # check if sudo is used
    if [[ "$(id -u)" -ne 0 ]]; then
        echo "Script must be run under sudo from the user you want to install for. Try 'sudo \$0'"
        exit 1
    fi

    # ensure that all needed OS packages are installed
    apt-get install -y wget unzip || (
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

        if [[ -f petrockblock_powerblock_master.zip ]]; then
            rm -f petrockblock_powerblock_master.zip
        fi

        # Download and extract the repository
        wget -O petrockblock_powerblock_master.zip https://github.com/petrockblog/PowerBlock/archive/master.zip
        unzip petrockblock_powerblock_master.zip
        rm petrockblock_powerblock_master.zip
        mv PowerBlock-master PowerBlock
        cd PowerBlock || exit
    fi

    # ensure that no old instance of the driver is running
    isOldServiceRunning=$(pgrep -f powerblock)
    if [[ -n $isOldServiceRunning ]]; then
        make uninstallservice
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

# ----------------------------------

prepare
installFiles
installService

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
