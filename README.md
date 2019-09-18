PowerBlock Driver
=================

This is the driver for the petrockblock.com [PowerBlock](https://blog.petrockblock.com/powerblock-raspberry-pi-power-switch/), 
which is an extension board for the Raspberry Pi (TM). The driver itself is denoted as _powerblock_ in the following. The 
driver provides a service for interacting with the power button signal as well as driving the optionally attached LED.

:exclamation: The following description is intended to be used in combination with a Raspberry Pi and a 
**Linux-based operating system** running on the Raspberry Pi. There is a **driver for Windows 10 IoT Core** that can be 
found at https://github.com/petrockblog/PowerBlockWinIoT/releases :exclamation:


## Installation

There comes an installation script with this reposity that does all the steps described below: `install.sh` This script 
compiles the driver, installs the binary and configuration files, and installs the PowerBlock service. 

To run the quick installation, you just need to call this one line from the Raspbian console

```bash
wget -O - https://raw.githubusercontent.com/petrockblog/PowerBlock/master/install.sh | sudo bash
```

To uninstall the service you can simply call `sudo ./uninstall.sh` from within the `PowerBlock` directory.


## Configuration

The configuration file of _powerblock_ is located at ```/etc/powerblockconfig.cfg```. It uses simple .ini file syntax <key>=<value> for setting the the values of its configuration parameters.

The parameters are explained in detail in the following:

 - ```activated```: Can be set to
     + ```1```: Activates the handling of the power switch signals of the PowerBlock.
     + ```0```: Deactivates the handling of the power switch signals of the PowerBlock.
 - ```statuspin```: Raspberry BCM pin used for status signaling (default: 17) connects to S2 on PowerBlock
 - ```shutdownpin```: Raspberry BCM pin used for shutdown signaling (default: 18) connects to S1 on Powerblock
 - ```logging```: Enables or disables logging via syslog to /var/log/syslog. The logging is enabled if set to 1.

## Logging

The PowerBlock driver logs certain events in the file `/var/log/syslog`.

## Shutdown Script

When the driver observes a shutdown signal from the PowerBlock, a shutdown Bash script is called. You can find and edit 
it at `/etc/powerblockswitchoff.sh`.

<br><br>
__Have fun!__

-Florian [petrockblock.com](http://blog.petrockblock.com)
