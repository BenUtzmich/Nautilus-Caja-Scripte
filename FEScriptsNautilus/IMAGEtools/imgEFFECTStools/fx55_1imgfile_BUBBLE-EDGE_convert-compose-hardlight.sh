#!/bin/sh
##
## NAUTILUS
## SCRIPT: 00_1imgfile_BUBBLE-EDGE_convert-compose-hardlight.sh
##
## PURPOSE: Makes a 'bubble-edged' image file from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for the '-raise' parameter
##          --- an integer (for number of pixels on the edges to 'bubble').
##
##          Uses ImageMagick 'convert' with the '-compose hardlight' option.
##
##          This script shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/thumbnails/#bubble
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
############################################################################
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
####################################################################

FILEEXT=`echo "$FILENAME" | cut -d\. -f2`


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


#######################################################
## Prompt for the '-raise' parameter.
#######################################################

RAISEPARM=""

RAISEPARM=$(zenity --entry \
   --title "Enter the BUBBLE-EDGE ('raise') parameter." \
   --text "\
Enter a BUBBLE-EDGE ('raise') parameter --- the number of
pixels in the 'bubbled' border.

Examples:   4   OR   6   OR   8   OR   10   OR   12   OR   24" \
   --entry-text "8")

if test "$RAISEPARM" = ""
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

OUTFILE="${FILEMIDNAME}_BUBBLE-EDGE${RAISEPARM}.$FILEEXT"

if test ! -w "$CURDIR"
then
   OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
   rm -f "$OUTFILE"
fi


#######################################################
## Use 'convert' to make the 'bubble overlay' PNG file.
#######################################################

OVERLAYFILE="/tmp/${USER}_bubble_overlay.png"

if test -f "$OVERLAYFILE"
then
   rm -f "$OVERLAYFILE"
fi

convert "$FILENAME" -fill gray50 -colorize 100% \
        -raise $RAISEPARM -normalize -blur 0x8 "$OVERLAYFILE"


###########################################
## Use 'convert' to make the new image file.
###########################################

## FOR TESTING: (show statements as they execute)
#      set -x

convert "$FILENAME" "$OVERLAYFILE" \
        -compose hardlight -composite  "$OUTFILE"

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
