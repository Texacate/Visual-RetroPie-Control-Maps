#!/bin/bash
# USAGE:  for_all_roms.sh
#
# builds a button_map image for every ROM on your collection.

FILES=/home/pi/RetroPie/roms/arcade/*.zip

for f in $FILES
do
   echo "Processing $f file..."
   rom=$(basename -- $f)
   rom="${rom%.*}"
#  echo "BASENAME: $rom"
   /home/pi/bin/button_map.sh $rom
done
