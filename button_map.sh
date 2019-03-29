#/bin/bash
# USAGE:  button_map.sh <rom_basename>

 export MAGICK_HOME="$HOME/Documents/Hobby/Arcade/ImageMagick-7.0.8"
 export PATH="$MAGICK_HOME/bin:$PATH"
 export DYLD_LIBRARY_PATH="$MAGICK_HOME/lib/"
 

## Set LOGO_DIR to the folder of containing artwork to be inclued at the top of the generated images
## Example for rom_name: pacman 
##  the program will look for artwork: ./wheel/pacman.png
LOGO_DIR="./wheel"

## Set CLONEDB to the file of parent/clone information
## Data format if rom is a parent:
##    parent_rom_name
## Data format if rom is a clone:
##    clone_rom_name,parent_rom_name
CLONEDB="./mame2003-plus.csv"


## Set BUTTONDB to  the database of button labels
## Data format: 
##    rom_name,button1_label,button2_label,button3_labal, ... ,button10_label
#BUTTONDB="./custom_map.csv"
BUTTONDB="./button_map.csv"
#BUTTONDB="./controls.csv"



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


BTN_DATA=""
PARENT=""
CLONE_OF=""
IFS=","

function get_parent_buttons () {
    local rom="$1"
    local name=""
    echo "Looking for $rom button map data"
    while read -r name b1 b2 b3 b4 b5 b6 b7 b8 b9 b10; do
        if [[ "$rom" == "$name" ]]; then
            echo "  Found $rom button map text"
	    BTN_DATA="$rom"
            return
        fi
    done < <(tr -d '\r' < "$BUTTONDB")
}

function get_parent_clone () {
    local rom="$1"
    local name=""
    local cloneof=""
    echo "Looking through parent/clone data for $rom"
    while read -r name cloneof; do
        if [[ "$rom" == "$name" ]]; then	
	    PARENT="$name"
	    if [ "$cloneof" == "" ]; then
               echo "  Found $rom, is parent rom"
	    else
               echo "  Found $rom, is clone of $cloneof"
	       CLONE_OF="$cloneof"
	    fi
            return
        fi
    done < <(tr -d '\r' < "$CLONEDB")
}

# Map database button order to retro pad 
function map_buttons_retro_pad () {
rpB="$b1"
rpA="$b2"
rpR="$b3"
rpY="$b4"
rpX="$b5"
rpL="$b6"
rpL2="$b7"
rpR2="$b8"
rpL3="$b9"
rpR3="$b10"
}

# Map retro pad button order to control panel layout
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

# returns the desired font point-size, based on the length of the button label string
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


function gen_not_found_png () {
  local rom="$1"
  local logo="$LOGO_DIR/$rom.png"
  local text=""
  echo "Creating place-holder image for $rom"

  if [ "$CLONE_OF" == "" ]; then
    text="$rom.zip"
  else
    text="$rom.zip ($CLONE_OF)"
  fi

  if [ -f $logo ]; then
    echo "  Adding wheel art $logo"
    magick convert $logo -resize 600x200  ./tmp/logo.resized.png
    magick convert -size 800x480 xc:black \
      ./tmp/logo.resized.png -gravity north  -geometry +0+50  -composite \
      -gravity south -font Arial -pointsize 50  -fill white -annotate +0+150 "No button data found for ROM:" \
      -gravity south -font Arial -pointsize 100 -fill white -annotate +0+30 "$rom.zip" \
      -gravity south_west -font ArialB -pointsize 20 -fill yellow -annotate +10+10 "$text" \
      ./tmp/$rom.png
  else
    magick convert -size 800x480 xc:black \
      -gravity center -font Arial -pointsize 50  -fill white -annotate +0-50 "No button data found for ROM:" \
      -gravity center -font Arial -pointsize 100 -fill white -annotate +0+50 "$rom.zip" \
      -gravity south_west -font ArialB -pointsize 20 -fill yellow -annotate +10+10 "$text" \
      ./tmp/$rom.png
  fi
  echo "Final image ./tmp/$rom.png"

}


function  get_button_color () {
  echo "  Getting buttom map colors for $BTN_DATA"
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
  if [ "$cp7" == "" ]; then  btn7_img="./src/blk_btn.png"
  else                       btn7_img="./src/grn_btn.png"
  fi
  if [ "$cp8" == "" ]; then  btn8_img="./src/blk_btn.png"
  else                       btn8_img="./src/grn_btn.png"
  fi
  if [ "$cp9" == "" ]; then  btn9_img="./src/blk_btn.png"
  else                       btn9_img="./src/grn_btn.png"
  fi
  if [ "$cp10" == "" ]; then  btn10_img="./src/blk_btn.png"
  else                        btn10_img="./src/grn_btn.png"
  fi
}
  
function get_font_sizes () {
  echo "  Calulating fonts for $BTN_DATA"
# font="ComicSansMSB"
  font="ArialNarrowB"
  calc_point $cp1;  pt1=$point
  calc_point $cp2;  pt2=$point
  calc_point $cp3;  pt3=$point
  calc_point $cp4;  pt4=$point
  calc_point $cp5;  pt5=$point
  calc_point $cp6;  pt6=$point
  calc_point $cp7;  pt7=$point
  calc_point $cp8;  pt8=$point
  calc_point $cp9;  pt9=$point
  calc_point $cp10;  pt10=$point
  #echo "$pt1 $pt2 $pt3 $pt4 $pt5 $pt5"
}

# Assumed layout of buttons on control panel
#      ___	___      ___ 
#    _|__|_   _|__|_   _|__|_
#   (_cp1_)  (_cp2_)  (_cp3_)
#      ___	___      ___ 
#    _|__|_   _|__|_   _|__|_
#   (_cp4_)  (_cp5_)  (_cp6_)
#   

function gen_annotated_png_6_button () {  
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
}

# Assumed layout of buttons on control panel
#      ___	___      ___      ___
#    _|__|_   _|__|_   _|__|_   _|__|_
#   (_cp1_)  (_cp2_)  (_cp3_)  (_cp7_)
#      ___	___      ___      ___ 
#    _|__|_   _|__|_   _|__|_   _|__|_
#   (_cp4_)  (_cp5_)  (_cp6_)  (_cp8_)
#   

function gen_annotated_png_8_button () {  
  sw=5  
  magick convert -size 2400x1440 xc:black \
    $btn1_img -gravity south  -geometry -750+550 -composite \
    $btn2_img -gravity south  -geometry -250+650 -composite \
    $btn3_img -gravity south  -geometry +250+750 -composite \
    $btn7_img -gravity south  -geometry +750+650 -composite \
    $btn4_img -gravity south  -geometry -750+50  -composite \
    $btn5_img -gravity south  -geometry -250+150 -composite \
    $btn6_img -gravity south  -geometry +250+250 -composite \
    $btn8_img -gravity south  -geometry +750+150 -composite \
    -gravity south -font $font -pointsize $pt1 -fill white -stroke black -strokewidth $sw -annotate -750+675 "$cp1" \
    -gravity south -font $font -pointsize $pt2 -fill white -stroke black -strokewidth $sw -annotate -250+775 "$cp2" \
    -gravity south -font $font -pointsize $pt3 -fill white -stroke black -strokewidth $sw -annotate +250+875 "$cp3" \
    -gravity south -font $font -pointsize $pt7 -fill white -stroke black -strokewidth $sw -annotate +750+775 "$cp7" \
    -gravity south -font $font -pointsize $pt4 -fill white -stroke black -strokewidth $sw -annotate -750+175 "$cp4" \
    -gravity south -font $font -pointsize $pt5 -fill white -stroke black -strokewidth $sw -annotate -250+275 "$cp5" \
    -gravity south -font $font -pointsize $pt6 -fill white -stroke black -strokewidth $sw -annotate +250+375 "$cp6" \
    -gravity south -font $font -pointsize $pt8 -fill white -stroke black -strokewidth $sw -annotate +750+275 "$cp8" \
    ./tmp/2_annotated.png
}

# Adds GAME-LOGO at top of the image, and romname in lower right corner
#
#     ==> GAME-LOGO  <==
#      ___	___      ___ 
#    _|__|_   _|__|_   _|__|_
#   (_cp1_)  (_cp2_)  (_cp3_)
#      ___	___      ___ 
#    _|__|_   _|__|_   _|__|_
#   (_cp4_)  (_cp5_)  (_cp6_)
#   
# romname(parent) <===
#

function gen_logo_png () {
  local text=""
  local rom="$1"
  local logo="$LOGO_DIR/$rom.png"
    
  if [ "$CLONE_OF" == "" ]; then
    text="$rom.zip"
  else
    text="$rom.zip ($CLONE_OF)"
  fi
  
  if [ -f $logo ]; then
    echo "  Adding wheel art $logo"
    magick convert $logo -resize 1500x275  ./tmp/logo.resized.png
    magick convert ./tmp/2_annotated.png \
      ./tmp/logo.resized.png -gravity north  -geometry +0+50  -composite \
      -gravity south_west -font ArialB -pointsize 60 -fill yellow -annotate +10+10 "$text" \
      -resize 800x480 ./arcade/$rom.png
  else
    echo "  No wheel art found for $rom"
    magick convert ./tmp/2_annotated.png \
      -gravity north -font Arial -pointsize 200 -fill white -annotate +0+50 "$rom.zip" \
      -gravity south_west -font ArialB -pointsize 60 -fill yellow -annotate +10+10 "$text" \
      -resize 800x480 ./arcade/$rom.png
  fi
  echo "Final image ./arcade/$rom.png"
}  

 
function print_globals () {
# echo "  LOGO_DIR: $LOGO_DIR"
# echo "  CLONEDB:  $CLONEDB"
# echo "  BUTTONDB: $BUTTONDB"
  echo "  PARENT:   $PARENT"
  echo "  CLONE_OF: $CLONE_OF"
  echo "  BTN_DATA: $BTN_DATA"
  echo "  BUTTON1: \"$b1\""
  echo "  BUTTON2: \"$b2\""
  echo "  BUTTON3: \"$b3\""
  echo "  BUTTON4: \"$b4\""
  echo "  BUTTON5: \"$b5\""
  echo "  BUTTON6: \"$b6\""
}


function gen_rom_button_map () {
  local rom="$1"
  echo "Building image for $rom.zip" 
  
  map_buttons_retro_pad 
  map_buttons_control_panel
  get_button_color
  get_font_sizes
  gen_annotated_png_6_button 
# gen_annotated_png_8_button 
  gen_logo_png $rom
}

echo "========================"
echo "|     MAIN PROGRAM     |"
echo "========================"


echo "Loading parent_clone database: $CLONEDB"
readonly CLONEDB

echo "Loading button map database: $BUTTONDB"
readonly BUTTONDB

get_parent_clone   $1
get_parent_buttons $1

if [ "$BTN_DATA" == "" ]; then
    if [ "$CLONE_OF" != "" ]; then
       echo "  No button data for $1, try parent"
       get_parent_buttons $CLONE_OF
    fi
fi

if [ "$BTN_DATA" == "" ]; then
    echo "  No button data available"
    gen_not_found_png $1
    print_globals
    exit
else
    gen_rom_button_map $1
    print_globals
    exit
fi


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


