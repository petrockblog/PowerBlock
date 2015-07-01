PowerBlock Driver
=================

This is the driver for the petrockblock.com PowerBlock, which is an extension board for the Raspberry Pi (TM). The driver itself is denoted as _powerblock_ in the following. The driver provides a service for interacting with the power button signal as well as driving the optionally attached LED.

## Prerequisites

To be able to successfully build _powerblock_ you need to have certain APT packages installed. You can make sure that you have the latest version of those packages with these commands:

```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y cmake g++-4.8
```

## Downloading the Sources

If you would like to download the latest version of _powerblock_ from [its Github repository](https://github.com/petrockblog/PowerBlock), you can use this command:
```bash
git clone https://github.com/petrockblog/PowerBlock.git
```

## Building and Installation

To build _controlblock_ follow these commands:
```bash
cd PowerBlock
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

<br><br>
__Have fun!__

-Florian [petrockblock.com](http://blog.petrockblock.com)
