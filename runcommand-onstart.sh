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

# Turn on the relevant LEDs for this game.
sudo /home/pi/bin/led-start "$system" "$game" >/dev/null

#  Send game info to picture server
python3 /home/pi/bin/simpleClient.py "OPEN $system $game" >/dev/null
