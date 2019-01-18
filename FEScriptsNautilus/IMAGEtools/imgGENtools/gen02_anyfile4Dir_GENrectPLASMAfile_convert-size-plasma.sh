#!/bin/sh
##
## NAUTILUS
## SCRIPT: gen02_anyfile4Dir_GENrectPLASMAfile_convert-size-plasma.sh
##
## PURPOSE: Creates a 'plasma' (random colors) image file, '.jpg'.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for
##          size of the image - WIDTH x HEIGHT in pixels.
##
##          Uses 'zenity --entry' to prompt the user for
##          a pair of colors to determine the colors in the image ---
##          the 'plasma gradient'
##
##          Uses ImageMagick 'convert' with the 'plasma:' parameter.
##
##          This script makes the output image file of type (suffix) '.jpg'.
##
##          This script shows the new image file in an image viewer of the
##          user's choice.
##
## Reference: http://www.imagemagick.org/Usage/canvas/#plasma
##
## HOW TO USE: In Nautilus, select ANY file in the directory in which
##             the new image file is to be created.
##             Then right-click and choose this script to run (name above).
##
##             The new, generated image file will be put in the current
##             directory, if the user has write permission there ---
##             otherwise the file is put in /tmp.
##
##########################################################################
## Created: 2012jan18
## Changed: 2012jan23 Add IMGSIZE to the output filename.
## Changed: 2012may14 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
###########################################################################

## FOR TESTING: (show statements as they execute)
#  set -x


#######################################################
## Prompt for the size (XXXxYYY) of the image file to be
## generated.
#######################################################

CURDIR="`pwd`"

IMGSIZE=""

IMGSIZE=$(zenity --entry --title "Enter IMAGE SIZE, XXXxYYY." \
        --text "\
Enter the image size (WIDTHxHEIGHT), in pixels,
of the 'plasma' (random colors) image file to be generated.

Example: 640x480

The new image filename will start with 'PLASMA' and will
be placed in the current directory:

$CURDIR

or in /tmp if you do not have write permission to the
current directory." \
        --entry-text "640x480")

if test "$IMGSIZE" = ""
then
    exit
fi


##########################################################
## Prompt for the plasma color pairs --- 'plasma gradient'.
##########################################################

COLORPAIR=""

COLORPAIR=$(zenity --entry --title "Enter a COLOR PAIR." \
        --text "\
Enter a color pair separated by a hyphen. Examples:
blue-white
#0000ff-#ffffff
yellow-black
green-yellow
red-blue
tomato-steelblue
tomato-tomato
grey-grey
random-random" \
        --entry-text "random-random")

if test "$COLORPAIR" = ""
then
    exit
fi


if test "$COLORPAIR" = "random-random"
then
   COLORPAIR=""
fi


##################################################################
## Make full filename for the output 'plasma' file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

COLORID="$COLORPAIR"

if test "$COLORPAIR" = ""
then
   COLORID="random-random"
fi


OUTFILE="PLASMA_${COLORID}_${IMGSIZE}.jpg"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


########################################################
## Call 'convert' to create the 'plasma' image file.
########################################################

convert  -size $IMGSIZE  plasma:$COLORPAIR  "$OUTFILE"


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
