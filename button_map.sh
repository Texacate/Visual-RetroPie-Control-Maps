#/bin/bash
# USAGE:  button_map.sh <rom_basename>

 export MAGICK_HOME="$HOME/Documents/Hobby/Arcade/ImageMagick-7.0.8"
 export PATH="$MAGICK_HOME/bin:$PATH"
 export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
 

#  LAYOUT
# ---------
#   Y X L
#   B A R


name=""
bB=""
bA=""
bR=""
bY=""
bX=""
bL=""


logo_dir=/Volumes/MacbookHD2/BITTOR/WOlfBackup/home/pi/RetroPie/roms/arcade/wheel

readonly LAYOUTS="keylayout.txt"
ROM="$1"
IFS="|"

function get_game_buttons () {
    while read -r name bB bA bR bY bX bL; do
        if [[ "$ROM" == "$name" ]]; then
            echo "Found rom $ROM button map text"
            return
        else
            echo "Looking for $ROM button map data"
        fi
    done < <(tr -d '\r' < "$LAYOUTS")
}

# call function
get_game_buttons

if [ "$name" == "" ]; then
  echo "No $1 button map Found. Exiting"
  exit
else 
  echo "ROMNAME: $name"
  echo "Button B: $bB"
  echo "Button A: $bA"
  echo "Button R: $bR"
  echo "Button Y: $bY"
  echo "Button X: $bX"
  echo "Button L: $bL"
fi



# 
echo "Building botton map compsite image  for $1"
if [ "$bY" == "" ]; then 
  magick composite ./src/blk_btn.png -gravity south -geometry -550+550 ./bkgn.png ./tmp/btn1.png  
else 
  magick composite ./src/grn_btn.png -gravity south -geometry -550+550 ./bkgn.png ./tmp/btn1.png  
fi
if [ "$bX" == "" ]; then
  magick composite ./src/blk_btn.png -gravity south -geometry   +0+675 ./tmp/btn1.png ./tmp/btn2.png
else
  magick composite ./src/grn_btn.png -gravity south -geometry   +0+675 ./tmp/btn1.png ./tmp/btn2.png
fi
if [ "$bL" == "" ]; then
  magick composite ./src/blk_btn.png -gravity south -geometry +550+550 ./tmp/btn2.png ./tmp/btn3.png
else
  magick composite ./src/grn_btn.png -gravity south -geometry +550+550 ./tmp/btn2.png ./tmp/btn3.png
fi
if [ "$bB" == "" ]; then
  magick composite ./src/blk_btn.png -gravity south -geometry -550+50  ./tmp/btn3.png ./tmp/btn4.png
else
  magick composite ./src/grn_btn.png -gravity south -geometry -550+50  ./tmp/btn3.png ./tmp/btn4.png
fi
if [ "$bA" == "" ]; then
  magick composite ./src/blk_btn.png -gravity south -geometry   +0+175 ./tmp/btn4.png ./tmp/btn5.png
else
  magick composite ./src/grn_btn.png -gravity south -geometry   +0+175 ./tmp/btn4.png ./tmp/btn5.png
fi
if [ "$bR" == "" ]; then
  magick composite ./src/blk_btn.png -gravity south -geometry +550+50  ./tmp/btn5.png ./tmp/btn6.png
else
  magick composite ./src/grn_btn.png -gravity south -geometry +550+50  ./tmp/btn5.png ./tmp/btn6.png
fi

echo "Annotating botton map image for $1"
font="ComicSansMSB"
pt=200
sw=5
magick convert ./tmp/btn6.png -gravity south -font $font -pointsize $pt -fill white -stroke black -strokewidth $sw -annotate -550+700 "$bY" ./tmp/btn1.png
magick convert ./tmp/btn1.png -gravity south -font $font -pointsize $pt -fill white -stroke black -strokewidth $sw -annotate   +0+825 "$bX" ./tmp/btn2.png
magick convert ./tmp/btn2.png -gravity south -font $font -pointsize $pt -fill white -stroke black -strokewidth $sw -annotate +550+700 "$bL" ./tmp/btn3.png
magick convert ./tmp/btn3.png -gravity south -font $font -pointsize $pt -fill white -stroke black -strokewidth $sw -annotate -550+200 "$bB" ./tmp/btn4.png
magick convert ./tmp/btn4.png -gravity south -font $font -pointsize $pt -fill white -stroke black -strokewidth $sw -annotate   +0+325 "$bA" ./tmp/btn5.png
magick convert ./tmp/btn5.png -gravity south -font $font -pointsize $pt -fill white -stroke black -strokewidth $sw -annotate +550+200 "$bR" ./tmp/btn6.png

logo=$logo_dir/$name.png
if [ -f $logo ]; then
  echo "Adding wheel art $logo"
  magick convert $logo -resize 1500x200  ./tmp/logo.resized.png
  magick composite -gravity north ./tmp/logo.resized.png ./tmp/btn6.png -geometry +0+50  ./tmp/game.png
else
  cp ./tmp/btn6.png  ./tmp/game.png
  echo "No wheel art found for $1"
fi

echo "Saving final image file: ./arcade/$1.png"
magick convert ./tmp/game.png -resize 800x480  ./arcade/$name.png


# available FONTS on my computer
# -------------------------------
#  AndaleMono	       CambriaBI	 FranklinGothicBook	  LucidaSansUnicode	 Skia
#  AppleChancery       CambriaI 	 FranklinGothicBookI	  Marlett		 Tahoma
#  AppleMyungjo        Candara  	 FranklinGothicM	  Meiryo		 TahomaB
#  Arial 	       CandaraB 	 FranklinGothicMI	  MeiryoB		 TimesNewRoman
#  ArialB	       CandaraBI	 GB18030Bitmap  	  MeiryoBI		 TimesNewRomanB
#  ArialBI	       CandaraI 	 Georgia		  MeiryoI		 TimesNewRomanBI
#  ArialBk	       Chalkduster	 GeorgiaB		  MicrosoftSansSerif	 TimesNewRomanI
#  ArialI	       ComicSans	 GeorgiaBI		  Mincho		 Trebuchet
#  ArialNarrow	       ComicSansMSB	 GeorgiaI		  Osaka 		 TrebuchetMSB
#  ArialNarrowB        Consolas 	 GillSans		  OsakaMono		 TrebuchetMSBI
#  ArialNarrowBI       ConsolasB	 GillSansB		  PCMyungjo		 TrebuchetMSI
#  ArialNarrowI        ConsolasBI	 GillSansBI		  Perpetua		 TwCen
#  ArialRoundedB       ConsolasI	 GillSansI		  PerpetuaB		 TwCenB
#  ArialUnicode        Constantia	 Gothic 		  PerpetuaBI		 TwCenBI
#  Ayuthaya	       ConstantiaB	 Gulim  		  PerpetuaI		 TwCenI
#  Batang	       ConstantiaI	 GungSeo		  PGothic		 Verdana
#  BigCaslonM	       ConstantiaTestI   Gurmukhi		  PilGi 		 VerdanaB
#  BookshelfSymbol7    Corbel		 HeadLineA		  PlantagenetCherokee	 VerdanaBI
#  BrushScriptI        CorbelI  	 Herculanum		  PMincho		 VerdanaI
#  Calibri	       CorbelTestB	 HoeflerTextOrnaments	  PMingLiU		 Webdings
#  CalibriB	       CorbelTestBI	 Impact 		  ReferenceSansSerif	 Wingdings
#  CalibriBI	       CourierNew	 InaiMathi		  ReferenceSpecialty	 Wingdings2
#  CalibriI	       CourierNewB	 Kokonor		  Sathu 		 Wingdings3
#  Cambria	       CourierNewBI	 Krungthep		  Silom 		 Zapfino
#  CambriaB	       CourierNewI	 LucidaConsole  	  SimSun

