#!/bin/bash

function prepare() {
    # check, if sudo is used
    if [[ "$(id -u)" -ne 0 ]]; then
        echo "Script must be run under sudo from the user you want to install for. Try 'sudo $0'"
        exit 1
    fi

    # ensure that all needed OS packages are installed
    apt-get install -y git || (c=$?; echo "Error during installation of APT packages"; (exit $c))

    # ensure that we are within the PowerBlock directory
    currentDirectory=${PWD##*/}
    if [[ $currentDirectory != "PowerBlock" ]]; then
        if [[ -d PowerBlock ]]; then
            rm -rf PowerBlock
        fi
        sudo -u $SUDO_USER git clone --recursive --depth=1 git://github.com/petrockblog/PowerBlock
        cd PowerBlock
    fi

    # ensure that no old instance of the driver is running
    isOldServiceRunning=$(ps -ef | grep powerblock | grep -v grep)
    if [[ ! -z $isOldServiceRunning ]]; then
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
if [[ ! -f /usr/bin/powerblock ]]; then
    echo "[ERROR] The PowerBlock driver binary is not installed"
else
    echo "[SUCCESS] The PowerBlock driver binary is installed"
fi

# check that the service is running
isServiceRunning=$(ps -ef | grep powerblock | grep -v grep)
if [[ ! -z $isServiceRunning ]]; then
    echo "[SUCCESS] The PowerBlock service is running"
else
    echo "[ERROR] The PowerBlock service is not running"
fi 

echo "You can find the configuration file at /etc/powerblockconfig.cfg".

