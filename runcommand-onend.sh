#!/usr/bin/bash

# ARGUMENTS, IN ORDER:
# 1. System (e.g., "arcade")
# 2. Emulator (e.g. "lr-fba-next")
# 3. Full path to game (e.g., /home/pi/RetroPie/roms/arcade/wjammers.zip)

if [ -z "$3" ]; then
  exit 0
fi

system=$1
emulator=$2

# Gets the basename of the game (e.g., "wjammers")
game=$(basename "$3")
game=${game%.*}

# sudo /home/pi/bin/led-end "$system" "$game" >/dev/null
sudo /home/pi/bin/led-start  10
sudo /home/pi/bin/led-start  10,8,13,16
sudo /home/pi/bin/led-start  10,8,13,16,1,4,12,15
sudo /home/pi/bin/led-start  10,8,13,16,1,4,12,15,2,5,11,14
sudo /home/pi/bin/led-start  10,8,13,16,1,4,12,15,2,5,11,14,3,6,9
sudo /home/pi/bin/led-start  10,8,13,16,1,4,12,15,2,5,11,14,3,6,9,7

#  Send game info to picture server
python3 /home/pi/bin/simpleClient.py "CLOSE" >/dev/null
python3 /home/pi/bin/simpleClient.py "OPEN all emulation_station" >/dev/null
