#!/bin/sh
##
## NAUTILUS
## SCRIPT: gen01_anyfile4Dir_GENrectGRADIENTfile_2color_convert-size-gradient.sh
##
## PURPOSE: Creates a 'gradient' (between 2 colors) image file, '.jpg'.
##
## METHOD:  Uses 'zenity --entry' to prompt the user for
##          size of the image - WIDTH x HEIGHT in pixels.
##
##          Uses 'zenity --entry' to prompt the user for
##          a pair of colors to determine the colors in the new image file.
##
##          Uses 'zenity --entry' to prompt the user for
##          the type of gradient. Example: radial-gradient.
##
##          Uses ImageMagick 'convert' with the 'gradient:' parameter.
##
##          This script makes the output image file of type (suffix) '.jpg'.
##
##          This script shows the new image file in an image viewer of the
##          user's choice.
##
## Reference: http://www.imagemagick.org/Usage/canvas/#gradient
##
## HOW TO USE: In Nautilus, select ANY file in the directory in which
##             the file is to be created.
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
of the 'gradient' image file to be generated.

Example: 640x480

You will also be prompted for
- a pair of colors to bias the colors in the image
- the type of gradient. Example: radial-gradient.

The new image filename will start with 'GRADIENT' and will
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
## Prompt for the gradient color pairs.
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
tomato-steelblue" \
        --entry-text "white-black")

if test "$COLORPAIR" = ""
then
    exit
fi


#######################################################
## Prompt for the gradient type.
#######################################################

GRADIENT_TYPE=""

GRADIENT_TYPE=`zenity --list --radiolist \
   --title "GRADIENT TYPE?" \
   --text "\
Choose a gradient type to apply to the selected image file.

NOTE: You can use other feNautilusScripts to ROTATE, mirrorHoriz,
mirrorVert this gradient file --- or MERGE ('blend' or 'dissolve')
this gradient file with another image file." \
   --column "" --column "GradientType" \
      TRUE  radial \
      FALSE linear-top-bottom \
      FALSE linear-top-center-bottom \
      FALSE ripples-4-top-down \
      FALSE swirl-top-bottom`

if test "$GRADIENT_TYPE" = ""
then
   exit
fi

# if test "$GRADIENT_TYPE" = "radial"
# then
   GRADIENT_PARM="radial-gradient:"
# fi

if test "$GRADIENT_TYPE" = "linear-top-bottom"
then
   GRADIENT_PARM="gradient:"
   # GRADIENT_PARM="gradient: -sigmoidal-contrast 6,50%"
   # GRADIENT_PARM="gradient: -evaluate cos 0.5 -negate"
fi

if test "$GRADIENT_TYPE" = "linear-top-center-bottom"
then
   GRADIENT_PARM="-function Polynomial -4,4,0 gradient:"
fi

if test "$GRADIENT_TYPE" = "ripples-4-top-down"
then
   GRADIENT_PARM="-function sinusoid 4,-90 gradient:"
fi

if test "$GRADIENT_TYPE" = "swirl-top-bottom"
then
   GRADIENT_PARM="-swirl 180 gradient:"
fi



##################################################################
## Make full filename for the output 'gradient' file.
##
## If the user has write-permission on the
## current directory, put the file in the pwd.
## Otherwise, put the file in /tmp.
##################################################################

CURDIR="`pwd`"

OUTFILE="GRADIENT_${COLORPAIR}_${GRADIENT_TYPE}_${IMGSIZE}.jpg"

if test ! -w "$CURDIR"
then
  OUTFILE="/tmp/$OUTFILE"
fi

if test -f "$OUTFILE"
then
  rm -f "$OUTFILE"
fi


########################################################
## Call 'convert' with the 'gradient:' option to create
## the 'gradient' image file.
########################################################

convert  -size $IMGSIZE  ${GRADIENT_PARM}$COLORPAIR  "$OUTFILE"


##########################
## Show the new image file.
##########################

## . $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

. $HOME/.freedomenv/feNautilusScripts/set_DIR_NautilusScripts.shi
. $DIR_NautilusScripts/.set_VIEWERvars.shi

$IMGVIEWER "$OUTFILE" &

# $IMGEDITOR "$OUTFILE" &
