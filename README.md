# Visual-RetroPie-Control-Maps
Displaying a visual map or legend of how the hardware control are mapped, on a RetroPie cabinet

Virtually every original arcade cabinet had a unique control layout, with different numbers of buttons. MAME cabinets are already a design compromise with buttons going used in many games. I wanted an easy way to remind myself what buttons cause what action, in any given arcade game.

The software consist of three main components

* Something to generate a set of button map images (ImageMagic)
* RPi1 must tell RPi2 what game is playing         (runcommand-onstart & simpleClinet.py)
* RPi2 must display the appropriate button map.    (simpleServer.py and fbi)

Discusison of the problem, and its many possible solutions are [here](https://retropie.org.uk/forum/topic/21464/show-control-panel-layout-before-game-starts-in-retropie-just-like-arcade1up-does).

The [project WIKI page](https://github.com/Texacate/Visual-RetroPie-Control-Maps/wiki) serves as the main documention page for the project.

Special thanks to:
* The entire [RetroPie](https://retropie.org.uk) project team
* The entire [ImageMagic](https://www.imagemagick.org) project team
* Alexander Baran-Harper for his [YouTube educational videos](https://www.youtube.com/watch?v=PYBZtV2-sLQ&list=PLNnwglGGYoTvy37TSGFlv-aFkpg7owWrE&index=31) on the Raspberry Pi 

