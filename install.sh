#!/bin/bash

# check, if sudo is used
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Script must be run under sudo from the user you want to install for. Try 'sudo $0'"
    exit 1
fi

# ensure that all needed OS packages are installed
apt-get install -y git cmake g++ doxygen build-essential || (c=$?; echo "Error during installation of APT packages"; (exit $c))

pushd /temp
wget https://project-downloads.drogon.net/wiringpi-latest.deb
dpkg -i wiringpi-latest.deb
popd

# ensure that we are within the PowerBlock directory
currentDirectory=${PWD##*/}
if [[ $currentDirectory != "PowerBlock" ]]; then
    if [[ -d PowerBlock ]]; then
        rm -rf PowerBlock
    fi
    git clone --recursive git://github.com/petrockblog/PowerBlock
    cd PowerBlock
fi

# make sure that the submodule data is available
git submodule update --init --recursive

if [[ -d build ]]; then
    rm -rf build
fi

# create a folder that will contain all build artefacts and change into that folder
mkdir build || (c=$?; echo "Error while creating build folder"; (exit $c))
pushd build || (c=$?; echo "Error while changing into the folder build"; (exit $c))

# create Makefiles
cmake .. || (c=$?; echo "Error while generating Makefiles"; (exit $c))

# ensure that no old instance of the driver is running
isOldServiceRunning=$(ps -ef | grep powerblock | grep -v grep)
if [[ $isOldServiceRunning -eq 1 ]]; then
    make uninstallservice
fi 

# build driver binary
make || (c=$?; echo "Error during building binary"; (exit $c))

# install the binary
make install || (c=$?; echo "Error during installation of binary"; (exit $c))

# install the driver as a service
make installservice || (c=$?; echo "Error during installation of service"; (exit $c))
sleep 3

# change back into the original folder
popd

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

