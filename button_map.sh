#/bin/bash
# USAGE:  button_map.sh <rom_basename>

 export MAGICK_HOME="$HOME/Documents/Hobby/Arcade/ImageMagick-7.0.8"
 export PATH="$MAGICK_HOME/bin:$PATH"
 export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
 

name=""
b1=""
b2=""
b3=""
b4=""
b5=""
b6=""
b7=""
b8=""
b9=""
b10=""
point=10

logo_dir="./wheel"

readonly LAYOUTS="./controls.csv"
ROM="$1"
IFS=","

function get_game_buttons () {
    echo "Loading button map database: $LAYOUTS"
    while read -r name b1 b2 b3 b4 b5 b6 b7 b8 b9 b10; do
        if [[ "$ROM" == "$name" ]]; then
            echo "Found rom $ROM button map text"
            return
        else
            echo "Looking for $ROM button map data"
        fi
    done < <(tr -d '\r' < "$LAYOUTS")
}

function map_buttons_retro_pad () {
rpB="$b1"
rpA="$b2"
rpY="$b3"
rpX="$b4"
rpL="$b5"
rpR="$b6"
rpL2="$b7"
rpR2="$b8"
rpL3="$b9"
rpR3="$b10"
}

function map_buttons_control_panel () {
cp1="$rpY"
cp2="$rpX"
cp3="$rpL"
cp4="$rpB"
cp5="$rpA"
cp6="$rpR"
cp7="$rpR2"
cp8="$rpL2"
cp9="$rpR3"
cp10="$rpL3"
}

# returns the desired font point-size, based on the string length
function calc_point () {
local string="$1"
local length="${#string}"
if    [ $length -le 10 ]; then point="200"
elif  [ $length -le 12 ]; then point="175"
elif  [ $length -le 15 ]; then point="150"
elif  [ $length -le 18 ]; then point="120"
elif  [ $length -le 20 ]; then point="100"
elif  [ $length -le 40 ]; then point="50"
else  point="25"
fi
#echo "calc_point ( $string $length ) = $point "
}


# call function
get_game_buttons
map_buttons_retro_pad
map_buttons_control_panel

if [ "$name" == "" ]; then
  echo "No $1 button map found. Exiting"
  exit
else 
  echo "ROMNAME: $name"
  echo "Button 1: $cp1"
  echo "Button 2: $cp2"
  echo "Button 3: $cp3"
  echo "Button 4: $cp4"
  echo "Button 5: $cp5"
  echo "Button 6: $cp6"
fi



#      ___	___      ___ 
#    _|__|_   _|__|_   _|__|_
#   (_cp1_)  (_cp2_)  (_cp3_)
#      ___	___      ___ 
#    _|__|_   _|__|_   _|__|_
#   (_cp4_)  (_cp5_)  (_cp6_)
#   
echo "Building botton map compsite image for $name"

if [ "$cp1" == "" ]; then  btn1_img="./src/blk_btn.png"
else                       btn1_img="./src/grn_btn.png"
fi
if [ "$cp2" == "" ]; then  btn2_img="./src/blk_btn.png"
else                       btn2_img="./src/grn_btn.png"
fi
if [ "$cp3" == "" ]; then  btn3_img="./src/blk_btn.png"
else                       btn3_img="./src/grn_btn.png"
fi
if [ "$cp4" == "" ]; then  btn4_img="./src/blk_btn.png"
else                       btn4_img="./src/grn_btn.png"
fi
if [ "$cp5" == "" ]; then  btn5_img="./src/blk_btn.png"
else                       btn5_img="./src/grn_btn.png"
fi
if [ "$cp6" == "" ]; then  btn6_img="./src/blk_btn.png"
else                       btn6_img="./src/grn_btn.png"
fi

echo "Annotating image with keylayout data for $name"
font="ComicSansMSB"
calc_point $cp1;  pt1=$point
calc_point $cp2;  pt2=$point
calc_point $cp3;  pt3=$point
calc_point $cp4;  pt4=$point
calc_point $cp5;  pt5=$point
calc_point $cp6;  pt6=$point
#echo "$pt1 $pt2 $pt3 $pt4 $pt5 $pt5"

sw=5

magick convert -size 2400x1440 xc:black \
 $btn1_img -gravity south  -geometry -550+550 -composite \
 $btn2_img -gravity south  -geometry   +0+675 -composite \
 $btn3_img -gravity south  -geometry +550+550 -composite \
 $btn4_img -gravity south  -geometry -550+50  -composite \
 $btn5_img -gravity south  -geometry   +0+175 -composite \
 $btn6_img -gravity south  -geometry +550+50  -composite \
 -gravity south -font $font -pointsize $pt1 -fill white -stroke black -strokewidth $sw -annotate -550+675 "$cp1" \
 -gravity south -font $font -pointsize $pt2 -fill white -stroke black -strokewidth $sw -annotate   +0+850 "$cp2" \
 -gravity south -font $font -pointsize $pt3 -fill white -stroke black -strokewidth $sw -annotate +550+675 "$cp3" \
 -gravity south -font $font -pointsize $pt4 -fill white -stroke black -strokewidth $sw -annotate -550+175 "$cp4" \
 -gravity south -font $font -pointsize $pt5 -fill white -stroke black -strokewidth $sw -annotate   +0+350 "$cp5" \
 -gravity south -font $font -pointsize $pt6 -fill white -stroke black -strokewidth $sw -annotate +550+175 "$cp6" \
 ./tmp/2_annotated.png


logo=$logo_dir/$name.png
if [ -f $logo ]; then
  echo "Adding wheel art $logo"
  magick convert $logo -resize 1500x200  ./tmp/logo.resized.png
  magick convert ./tmp/2_annotated.png \
   ./tmp/logo.resized.png -gravity north  -geometry +0+50  -composite \
    -resize 800x480 ./arcade/$name.png
else
  echo "No wheel art found for $name"
  magick convert ./tmp/2_annotated.png -gravity north -font Arial -pointsize 200 -fill white -annotate +0+50 "$name" -resize 800x480 ./arcade/$name.png
fi

#echo "Saving final image file: ./arcade/$name.png"
#magick convert ./tmp/3_game.png -resize 800x480  ./arcade/$name.png


# available FONTS on my computer
# -------------------------------
# AndaleMono		CambriaBI	FranklinGothicBook	LucidaSansUnicode	Skia
# AppleChancery		CambriaI	FranklinGothicBookI	Marlett			Tahoma
# AppleMyungjo		Candara 	FranklinGothicM		Meiryo			TahomaB
# Arial			CandaraB	FranklinGothicMI	MeiryoB			TimesNewRoman
# ArialB		CandaraBI	GB18030Bitmap		MeiryoBI		TimesNewRomanB
# ArialBI		CandaraI	Georgia			MeiryoI			TimesNewRomanBI
# ArialBk		Chalkduster	GeorgiaB		MicrosoftSansSerif	TimesNewRomanI
# ArialI		ComicSans	GeorgiaBI		Mincho			Trebuchet
# ArialNarrow		ComicSansMSB	GeorgiaI		Osaka			TrebuchetMSB
# ArialNarrowB		Consolas	GillSans		OsakaMono		TrebuchetMSBI
# ArialNarrowBI		ConsolasB	GillSansB		PCMyungjo		TrebuchetMSI
# ArialNarrowI		ConsolasBI	GillSansBI		Perpetua		TwCen
# ArialRoundedB		ConsolasI	GillSansI		PerpetuaB		TwCenB
# ArialUnicode		Constantia	Gothic			PerpetuaBI		TwCenBI
# Ayuthaya		ConstantiaB	Gulim			PerpetuaI		TwCenI
# Batang		ConstantiaI	GungSeo			PGothic			Verdana
# BigCaslonM		ConstantiaTestI Gurmukhi		PilGi			VerdanaB
# BookshelfSymbol7 	Corbel		HeadLineA		PlantagenetCherokee	VerdanaBI
# BrushScriptI		CorbelI		Herculanum		PMincho			VerdanaI
# Calibri		CorbelTestB	HoeflerTextOrnaments	PMingLiU		Webdings
# CalibriB		CorbelTestBI	Impact			ReferenceSansSerif	Wingdings
# CalibriBI		CourierNew	InaiMathi		ReferenceSpecialty	Wingdings2
# CalibriI		CourierNewB	Kokonor			Sathu			Wingdings3
# Cambria		CourierNewBI	Krungthep		Silom			Zapfino
# CambriaB		CourierNewI	LucidaConsole		SimSun
