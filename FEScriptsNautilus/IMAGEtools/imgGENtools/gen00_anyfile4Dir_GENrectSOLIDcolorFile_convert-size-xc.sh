#!/bin/sh
##
## NAUTILUS
## SCRIPT: gen00_anyfile4Dir_GENrectSOLIDcolorFile_convert-size-xc.sh
##
## PURPOSE: Creates a 'solid color' image file, '.jpg' --- of a user-specified
##          size --- width-height, in pixels.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for
##          size of the image - WIDTH x HEIGHT in pixels.
##
##          Uses 'zenity --entry' to prompt the user for
##          a color for the image.
##
##          Uses ImageMagick 'convert' with the 'xc:' parameter.
##
##          This script makes the output image file of type (suffix) '.jpg'.
##          (We could add a prompt for type --- jpg, png, gif, or others.)
##
##          This script shows the new image file in an image viewer of the
##          user's choice.
##
## References: http://www.imagemagick.org/Usage/canvas/#solid
##             http://stackoverflow.com/questions/7771975/imagemagick-create-a-png-file-which-is-just-a-solid-rectangle
##             http://www.imagemagick.org/script/color.php
##
## HOW TO USE: In Nautilus, select ANY file in the directory in which
##             the new image file is to be created.
##             Then right-click and choose this script to run (name above).
##
##             The new, generated image file will be put in the current
##             directory, if the user has write permission there ---
##             otherwise the file is put in /tmp.
##
###############################################################################
## Created: 2012jan23
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
for the 'SOLID COLOR' image file to be generated.

Example: 640x480

The image filename will start with 'SOLID-COLOR' and will
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
## Prompt for the solid color.
##########################################################

SOLIDCOLOR=""

SOLIDCOLOR=$(zenity --entry --title "Enter a COLOR." \
        --text "\
Enter a color. (Transparency is possible.) Examples:

#000000   OR   black   OR   rgb(0,0,0)
#ffffff   OR   white   OR   rgb(255,255,255)   OR   rgb(100%,100%,100%)

#ff0000   OR   red   OR   rgb(255, 0, 0)   OR   rgb(100%, 0%, 0%)
          OR   rgba(255, 0, 0, 1.0)   OR   rgba(100%, 0%, 0%, 0.5)

#00ff00   OR   green  OR   rgb(0,255,0)
#0000ff   OR   blue  OR   rgb(0,0,255)
#ffff00   OR   yellow  OR   rgb(255,255,0)

tomato
LightSteelBlue

#808080   OR   gray   OR    gray(50%)   OR   graya(50%, 0.5)
gray0  to  gray100

transparent   OR   none   OR   rgba( 0, 0, 0, 0.0)" \
        --entry-text "#000000")

if test "$SOLIDCOLOR" = ""
then
    exit
fi


##################################################################
## Make full filename for the output 'plasma' file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="SOLID-COLOR_${SOLIDCOLOR}_${IMGSIZE}.jpg"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


########################################################
## Call 'convert' to make the SOLID-COLOR image file.
########################################################

convert  -size $IMGSIZE  xc:$SOLIDCOLOR  "$OUTFILE"


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
