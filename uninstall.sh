#!/bin/bash

# check, if sudo is used
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Script must be run under sudo from the user you want to install for. Try 'sudo $0'"
    exit 1
fi

# ensure that all needed OS packages are installed
apt-get install -y git cmake g++-4.9 doxygen || (c=$?; echo "Error during installation of APT packages"; (exit $c))

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

# ensure that no old instance of the driver is running and installed
make uninstallservice
popd

# check that the service is not running anymore
ps -ef | grep powerblock | grep -v grep
[ $?  -eq "0" ] && echo "[ERROR] Could not remove the PowerBlock service" || echo "[SUCCESS] The PowerBlock service was successfully removed."

