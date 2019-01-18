#!/bin/sh
##
## NAUTILUS
## SCRIPT: 13_1imgfile_LAID-BACKperspectivePNG_convert-distort.sh
##
## PURPOSE: Makes a 'laid-back' image (a perspective image - top vanishing
##          toward the horizon effect) from a selected image file.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for an indent (in pixels)
##          for the top left and right of the input image.
##
##          Uses 'zenity --entry' to prompt the user for a background color
##          to use to fill in the background on the left and right sides
##          of the 'laid back' image.
##
##          Uses ImageMagick 'convert' with the '-distort' option.
##
##          Shows the new image file in an image viewer (or editor)
##          of the user's choice.
##
## Reference: http://www.imagemagick.org/Usage/distorts/#bilinear
##
## HOW TO USE: In Nautilus, select an image file.
##             Then right-click and choose this script to run (name above).
##
##########################################################################
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


##########################################################
## Get the input filesize, x and y, in pixels.
##########################################################

SIZEXY=`identify "$FILENAME" | head -1 | awk '{print $3}'`
SIZEX=`echo "$SIZEXY" | cut -dx -f1`
SIZEY=`echo "$SIZEXY" | cut -dx -f2`


#######################################################
## Prompt for the TOP-INDENT-PIXELS.
#######################################################

TOPINDENT_PIXELS=""

TOPINDENT_PIXELS=$(zenity --entry \
   --title "Enter TOP-INDENT-PIXELS." \
   --text "\
Enter NUMBER OF PIXELS to indent the image at the top left and right.

NOTE: This will determine how 'fast' the top of the image seems to be
receding toward the horizon." \
   --entry-text "100")

if test "$TOPINDENT_PIXELS" = ""
then
   exit
fi


#######################################################
## Set XTOPLEFT and XTOPRIGHT variables.
#######################################################

XTOPLEFT=$TOPINDENT_PIXELS
XTOPRIGHT=`expr $SIZEX - $TOPINDENT_PIXELS`


#######################################################
## Prompt for the BACKGROUND COLOR parameter.
#######################################################

BKGND_COLOR=""

BKGND_COLOR=$(zenity --entry \
   --title "Enter BACKGROUND COLOR." \
   --text "\
Enter a BACKGROUND COLOR --- to fill in the background on the
left and right sides of the 'laid back' output image.

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

OUTFILE="${FILEMIDNAME}_LAIDBACK_ON${BKGND_COLOR}_TOPINDENT${TOPINDENT_PIXELS}.png"

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

## FOR TESTING: (show the statements as they execute)
#      set -x

TRANSFORM_4POINT="0,0 ${XTOPLEFT},$TOPINDENT_PIXELS  \
   $SIZEX,0 ${XTOPRIGHT},$TOPINDENT_PIXELS  \
   ${SIZEX},$SIZEY ${SIZEX},$SIZEY   0,$SIZEY 0,$SIZEY"

convert "$FILENAME"  -matte  -virtual-pixel $BKGND_COLOR \
        -distort Perspective "$TRANSFORM_4POINT" \
        "$OUTFILE"

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
