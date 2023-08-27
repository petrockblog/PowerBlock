#!/usr/bin/env bash

echo "Starting the installation of the PowerBlock service for LibreELEC"

wget https://raw.githubusercontent.com/petrockblog/PowerBlock/master/scripts/libreelec/powerblock.sh
mv powerblock.sh /storage/
chmod +x /storage/powerblock.sh

wget https://raw.githubusercontent.com/petrockblog/PowerBlock/master/scripts/libreelec/autostart.sh
mv autostart.sh /storage/.config/
chmod +x /storage/.config/autostart.sh

/storage/powerblock.sh &

echo "Finished installing the PowerBlock service."
