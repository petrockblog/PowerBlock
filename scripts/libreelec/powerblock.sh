#!/usr/bin/env bash

# ------------ USER CONFIGURATION HERE --------------

IS_ACTIVATED=1
STATUS_PIN=17
SHUTDOWN_PIN=18
DO_LOGGING=1

# ------------ NO EDITING BELOW THIS LINE -----------


VERSION_MAJOR=2
VERSION_MINOR=0
VERSION_PATCH=0

# Common path for all GPIO access
BASE_GPIO_PATH=/sys/class/gpio

# Assign names to states
STATE_ON="1"
STATE_OFF="0"

# ------------------- FUNCTION DEFINITIONS ---------------

# Exports a pin if not already exported
# Parameter $1: pin number
exportPin() {
  if [ ! -e $BASE_GPIO_PATH/gpio$1 ]; then
    echo "$1" > $BASE_GPIO_PATH/export
  fi
}

# Set a pin as an output
# Parameter $1: pin number to be set as output pin
setDirectionOutput() {
  echo "out" > $BASE_GPIO_PATH/gpio$1/direction
}

# Set a pin as an output
# Parameter $1: pin number to be set as output pin
setDirectionInput() {
  echo "in" > $BASE_GPIO_PATH/gpio$1/direction
}

# Set value of a pin
# Parameter $1: pin number
# Parameter $2: output value. Can be 0 or 1
setPinValue() {
  echo $2 > $BASE_GPIO_PATH/gpio$1/value
}

# Returns the current pin value
# Parameter $1: pin number to be read from
getPinValue() {
  echo $(cat $BASE_GPIO_PATH/gpio$1/value)
}

# ---------------- LOGGING FUNCTIONALITY ---------------

# If the logger is enabled ($DO_LOGGING != 0), log events are written 
# into syslog at /var/log/syslog. NOt working per default in Libreelec
write_log() 
{
  if [[ $DO_LOGGING != 0 ]]; then
    while read text
    do 
      logger -t powerblockservice $text
    done
  fi
}


# ---------------- BEGIN OF MAIN PART ------------------

echo "Starting PowerBlock driver, version $VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH"

if [[ $IS_ACTIVATED == 0 ]]; then
  echo "Shutdown is DEACTIVATED"
else
  echo "Shutdown is ACTIVATED"
fi
echo "Shutdown Pin is $SHUTDOWN_PIN"
echo "Status Pin is $STATUS_PIN"

exportPin $STATUS_PIN
exportPin $SHUTDOWN_PIN

setDirectionOutput $STATUS_PIN
setDirectionInput $SHUTDOWN_PIN

echo "Setting RPi status signal to HIGH"
setPinValue $STATUS_PIN $STATE_ON

stopRunning() {
  echo "Exiting PowerBlock driver."
  exit
}

# Ctrl-C handler for clean shutdown
trap stopRunning SIGINT
trap stopRunning SIGQUIT
trap stopRunning SIGABRT
trap stopRunning SIGTERM

isShutdownRunning=0
while [ 1 ]
do
  sleep 1
  if [[ $IS_ACTIVATED != 0  ]]; then
    currentValue=$(getPinValue $SHUTDOWN_PIN)
    if [ $currentValue -eq $STATE_ON ]; then
      if [ $isShutdownRunning -eq 0 ]; then
        echo "Shutdown signal observed. Executing shutdownscript $SHUTDOWNSCRIPT and initiating shutdown."
        shutdown -h now &
        isShutdownRunning=1
      fi
    fi
  fi
done
