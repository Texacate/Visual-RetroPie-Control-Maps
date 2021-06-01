# Visual-RetroPie-Control-Maps
Displaying a visual map or legend of how the in-game actions are mapped to the hardware control on my RetroPie cabinet

Virtually every original arcade cabinet had a unique control layout, with different numbers of buttons. MAME cabinets are already a design compromise with buttons going unused in many games. I wanted an easy way to remind myself what buttons cause what action, in any given arcade game.

The software consist of three main components

* Something to generate a set of button map images (button_map.sh & ImageMagic)
* RPi1 must tell RPi2 what game is playing         (runcommand-onstart.sh & simpleClient.py)
* RPi2 must display the appropriate button map.    (simpleServer.py & fbi)

Discusison of the problem, and its many possible solutions are [here](https://retropie.org.uk/forum/topic/21464/show-control-panel-layout-before-game-starts-in-retropie-just-like-arcade1up-does).

For my project, the [WIKI page](https://github.com/Texacate/Visual-RetroPie-Control-Maps/wiki) serves as the main documention. How I appoached the issues, what hardware was used, where all the scripts go, and how they work are all described in the wiki.  Some help simplifing the wiki would be appreciated.

Special thanks to:
* The entire [RetroPie](https://retropie.org.uk) project team
* The entire [ImageMagic](https://www.imagemagick.org) project team
* Alexander Baran-Harper for his [YouTube educational videos](https://www.youtube.com/watch?v=PYBZtV2-sLQ&list=PLNnwglGGYoTvy37TSGFlv-aFkpg7owWrE&index=31) on the Raspberry Pi
* Kevin Jonas (SirPoonga), Howard Casto and the [controls.dat](http://controls.arcadecontrols.com) project contributors
* @yo1dog and the [controls-dat-jason](https://github.com/yo1dog/controls-dat-json) project  
* @markwkidd and the [lr-mame2003-plus](https://github.com/libretro/mame2003-plus-libretro/blob/master/src/controls.c) project contributors 

