PowerBlock Driver
=================

[![Build Status](https://travis-ci.org/petrockblog/PowerBlock.svg?branch=master)](https://travis-ci.org/petrockblog/PowerBlock)

This is the driver for the petrockblock.com PowerBlock, which is an extension board for the Raspberry Pi (TM). The driver itself is denoted as _powerblock_ in the following. The driver provides a service for interacting with the power button signal as well as driving the optionally attached LED.

## Quick Installation

There comes an installation script with this reposity that does all the steps described below: `install.sh` This script compiles the driver, installs the binary and configuration files, and installs the PowerBlock service. 

To run the quick installation, you just need to call this one line from the Raspbian console

```bash
wget -O - https://raw.githubusercontent.com/petrockblog/PowerBlock/master/install.sh | sudo bash
```

To uninstall the service you can simply call `sudo ./uninstall.sh` from within the `PowerBlock` directory.


## Prerequisites

If you did not follow the quick installation instructions above, you can manually execute the steps of the installation script. These are described in the following.

To be able to successfully build _powerblock_ you need to have certain APT packages installed. You can make sure that you have the latest version of those packages with these commands:

```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y cmake g++-4.9 doxygen build-essential
```

## Downloading the Sources

If you would like to download the latest version of _powerblock_ from [its Github repository](https://github.com/petrockblog/PowerBlock), you can use this command:
```bash
git clone --recursive https://github.com/petrockblog/PowerBlock.git
```

## Building and Installation

To build the PowerBlock driver binary follow these commands:
```bash
cd PowerBlock
mkdir build && cd build
cmake ..
make
```

If everything went fine you can install with the command
```bash
sudo make install
```

## Installation as Service

You can install _powerblock_ as daemon with this command:
```bash
sudo make installservice
```

It might be that you need to **restart** your Raspberry afterwards to have all needed services running.

## Uninstalling the service and/or the binary

You can uninstall the daemon with this command:
```bash
sudo make uninstallservice
```

You can uninstall the binary with this command:
```bash
sudo make uninstall
```

## Configuration

The configuration file of _powerblock_ is located at ```/etc/powerblockconfig.cfg```. It uses JSON syntax for setting the the values of its configuration parameters.

The parameters are explained in detail in the following:

 - ```powerswitch - activated```: Can be set to
     + ```true```: Activates the handling of the power switch signals of the PowerBlock.
     + ```false```: Deactivates the handling of the power switch signals of the PowerBlock.
 - ```statuspin```: Raspberry BCM pin used for status signaling (default: 17) connects to S2 on PowerBlock
 - ```shutdownpin```: Raspberry BCM pin used for shutdown signaling (default: 18) connects to S1 on Powerblock

## Logging

The PowerBlock driver logs certain events in the file `/var/log/powerblock.log`.

## Shutdown Script

When the driver observes a shutdown signal from the PowerBlock, a shutdown Bash script is called. You can find and edit it at `/etc/powerblockswitchoff.sh`.

<br><br>
__Have fun!__

-Florian [petrockblock.com](http://blog.petrockblock.com)
