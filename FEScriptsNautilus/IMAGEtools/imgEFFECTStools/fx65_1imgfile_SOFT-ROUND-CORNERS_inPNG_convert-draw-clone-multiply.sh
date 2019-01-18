#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_SOFT-ROUND-CORNERS_inPNG_convert-draw-clone-multiply.sh
##
## PURPOSE: Makes an image file with 'soft' (transparent to semi-transparent)
##          rounded corners from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for
##          the corner-radius parameter --- in pixels.
##
##          Uses ImageMagick 'convert' with '-draw' and '+clone'
##          and '-compose Multiply' and other options.
##
##          This script shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## References: http://www.imagemagick.org/Usage/thumbnails/#soft_edges
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012jan23
## Changed: 2012may14 Touched up the comments above. Changed some indenting below.
###########################################################################


## FOR TESTING: (show statements as they execute)
#  set -x

########################################
## Get the filename of the selected file.
########################################

   FILENAME="$1"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_URIS"
#  FILENAMES="$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"


####################################################################
## Get the file extension.
##     Assumes one period (.) in filename, at the extension.
##  COMMENTED, for now.
####################################################################

# FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


####################################################################
## Check that the file extension is 'jpg' or 'png' or 'gif'.
##     Assumes one period (.) in filename, at the extension.
## COMMENTED, for now.
####################################################################
 
# if test "$FILEEXT" != "jpg" -a "$FILEEXT" != "png" -a "$FILEEXT" != "gif"
# then
#    exit
# fi


##########################################################
## Get the 'midname' of the input file, to use to name the
## new output file.
##     Assumes just one period (.) in the filename,
##     at the suffix.
######################################################

FILEMIDNAME=`echo "$FILENAME" | cut -d'.' -f1`


#########################################################
## Prompt for the radius-of-corners (in pixels) parameter.
#########################################################

RAD=""

RAD=$(zenity --entry \
   --title "Enter the CORNER-RADIUS parameter." \
   --text "\
Enter a CORNER-RADIUS, in pixels.

Examples:  15   OR   25   OR   50   OR   75   OR 100" \
   --entry-text "25")

if test "$RAD" = ""
then
   exit
fi



##################################################################
## Make full filename for the output file --- using the
## name of the input file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="${FILEMIDNAME}_SOFT-ROUND-CORNERS${RAD}.png"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


###########################################
## Use 'convert' to make the new image file.
###########################################

## FOR TESTING: (show statements as they execute)
#      set -x

# convert "$FILENAME" -alpha set -virtual-pixel Transparent \
#         -channel A -blur 0x8  -level 50%,100%  +channel \
#         "$OUTFILE"
## NOT WORKING. Corners unaffected.


DRAWPARM="fill black polygon 0,0 0,$RAD $RAD,0 fill white circle $RAD,$RAD $RAD,0"

convert "$FILENAME" \
     \( +clone  -alpha extract \
     -draw "$DRAWPARM" \
        \( +clone -flip \) -compose Multiply -composite \
        \( +clone -flop \) -compose Multiply -composite \
     \) -alpha off -compose CopyOpacity -composite "$OUTFILE"

## FOR TESTING: (turn off display of statements)
#      set -


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
