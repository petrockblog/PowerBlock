#!/usr/bin/env bash

VERSION_MAJOR=2
VERSION_MINOR=0
VERSION_PATCH=0

# Common path for all GPIO access
BASE_GPIO_PATH=/sys/class/gpio

# Assign names to states
STATE_ON="1"
STATE_OFF="0"

CONFIGFILE=/etc/powerblockconfig.cfg
SHUTDOWNSCRIPT=/etc/powerblockswitchoff.sh


# ------------------- FUNCTION DEFINITIONS ---------------

# thanks to https://stackoverflow.com/a/54597545
function iniget() {
  if [[ $# -lt 2 || ! -f $1 ]]; then
    echo "usage: iniget <file> [--list|<section> [key]]"
    return 1
  fi
  local inifile=$1

  if [ "$2" == "--list" ]; then
    for section in $(cat $inifile | grep "\[" | sed -e "s#\[##g" | sed -e "s#\]##g"); do
      echo $section
    done
    return 0
  fi

  local section=$2
  local key
  [ $# -eq 3 ] && key=$3

  # https://stackoverflow.com/questions/49399984/parsing-ini-file-in-bash
  # This awk line turns ini sections => [section-name]key=value
  local lines=$(awk '/\[/{prefix=$0; next} $1{print prefix $0}' $inifile)
  for line in $lines; do
    if [[ "$line" = \[$section\]* ]]; then
      local keyval=$(echo $line | sed -e "s/^\[$section\]//")
      if [[ -z "$key" ]]; then
        echo $keyval
      else          
        if [[ "$keyval" = $key=* ]]; then
          echo $(echo $keyval | sed -e "s/^$key=//")
        fi
      fi
    fi
  done
}

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

doShutdown() {
  exec $SHUTDOWNSCRIPT &
}

checkForRoot() {
  # check if run as root
  if [ "$EUID" -ne 0 ]
    then echo "ERROR: powerblockservice needs to be run as root."
    exit
  fi
}

# ---------------- LOGGING FUNCTIONALITY ---------------

# If the logger is enabled ($DO_LOGGING != 0), log events are written 
# into syslog at /var/log/syslog.
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

checkForRoot

# read configuration
IS_ACTIVATED=$(iniget $CONFIGFILE powerblock activated)
STATUS_PIN=$(iniget $CONFIGFILE powerblock statuspin)
SHUTDOWN_PIN=$(iniget $CONFIGFILE powerblock shutdownpin)
DO_LOGGING=$(iniget $CONFIGFILE powerblock logging)

echo "Starting PowerBlock driver, version $VERSION_MAJOR.$VERSION_MINOR.$VERSION_PATCH" | write_log

if [[ $IS_ACTIVATED == 0 ]]; then
  echo "Shutdown is DEACTIVATED" | write_log
else
  echo "Shutdown is ACTIVATED" | write_log
fi
echo "Shutdown Pin is $SHUTDOWN_PIN" | write_log
echo "Status Pin is $STATUS_PIN" | write_log

exportPin $STATUS_PIN
exportPin $SHUTDOWN_PIN

setDirectionOutput $STATUS_PIN
setDirectionInput $SHUTDOWN_PIN

echo "Setting RPi status signal to HIGH" | write_log
setPinValue $STATUS_PIN $STATE_ON

stopRunning() {
  echo "Exiting PowerBlock driver." | write_log
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
        echo "Shutdown signal observed. Executing shutdownscript $SHUTDOWNSCRIPT and initiating shutdown." | write_log
        doShutdown
        isShutdownRunning=1
      fi
    fi
  fi
done

