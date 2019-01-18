#!/bin/sh
##
## NAUTILUS
## SCRIPT: fx48_1imgfile_toARCinPNG_convert-distort.sh
##
## PURPOSE: Makes an 'arc' image (distorts an image into a circular arc)
##          from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for the degrees
##          of arc to make.
##
##          Uses 'zenity --entry' to prompt the user for a background color
##          to use to fill in the background on the perimeter of the arc-ed
##          image.
##
##         Uses ImageMagick 'convert' with the '-distort' option.
##
##          Shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/distorts/#arc
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
###########################################################################
## Created: 2012feb01
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
## COMMENTED, for now.  (We will use a PNG file for output.)
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


#######################################################
## Prompt for the DEGREES of ARC.
#######################################################

DEGREESofARC=""

DEGREESofARC=$(zenity --entry \
   --title "Enter DEGREES of ARC." \
   --text "\
Enter NUMBER OF DEGREES of ARC in which to map the selected image.

Examples: 60  OR  90  OR  120  OR  150  OR  180  OR  210  OR  240  OR
270  OR  300  OR  330  OR  360" \
   --entry-text "60")

if test "$DEGREESofARC" = ""
then
   exit
fi


#######################################################
## Prompt for the BACKGROUND COLOR parameter.
#######################################################

BKGND_COLOR=""

BKGND_COLOR=$(zenity --entry \
   --title "Enter BACKGROUND COLOR." \
   --text "\
Enter a BACKGROUND COLOR --- to fill in the background on the
permimeter of the 'arc' output image.

Examples:
black   OR   #000000
white   OR   #ffffff
red     OR   #ff0000
green   OR   #00ff00
blue    OR   #0000ff
midgray   OR  #808080
transparent 
" \
   --entry-text "transparent")

if test "$BKGND_COLOR" = ""
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

OUTFILE="${FILEMIDNAME}_ARC${DEGREESofARC}_BKGND${BKGND_COLOR}.png"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


#################################################################
## Use 'convert' to make the new image file ---
## with a 4-point mapping of the corners of a square in the image
## --- top-left, top-right, bottom-right, bottom-left.
#################################################################

## FOR TESTING: (show statements as they execute)
#      set -x

convert "$FILENAME" -matte -virtual-pixel $BKGND_COLOR \
        -distort Arc $DEGREESofARC "$OUTFILE"

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
