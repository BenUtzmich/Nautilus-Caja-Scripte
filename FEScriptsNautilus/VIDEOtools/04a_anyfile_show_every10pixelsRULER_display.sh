#!/bin/sh
##
## Nautilus
## SCRIPT: 04a_anyfile_show_every10pixelsRULER_display.sh
##
## PURPOSE: Starts up a window showing a 'ruler' GIF file 
##          with lines every 10 pixels.
##
## METHOD:  Uses 'zenity --list --radiolist' to offer a choice of Vertical
##          or a Horizontal ruler.
##
##          Uses ImageMagick 'display -immutable' to show the
##          appropriate GIF file.
##
## HOW TO USE: In Nautilus, select ANY file in ANY directory.
##             Then right-click and choose this script to run (name above).
##
##          This utility is typically used by moving the rule-file window
##          next to an image (could be a video image), to
##          determine how many pixels to crop from the image.
##
###########################################################################
## Created: 2011feb02
## Changed: 2012may22 Changed script name in comments above and touched up
##                    the comments. Changed some indenting below.
######################################################################

## FOR TESTING: (show statements as they execute)
#   set -x


#######################################################
## Prompt for Vertical or Horizontal ruler.
#######################################################

RULERTYPE="Vert"

RULERTYPE=$(zenity --list --radiolist \
   --title "VERTical or HORIZontal ruler?" \
   --text "Choose one of the following types:" \
   --column "" --column "Type" \
   TRUE Vert FALSE Horiz)

if test "$RULERTYPE" = ""
then
   exit
fi


#######################################
## Set the RULER filename to display.
#######################################
## The ruler files should be in the
## same directory as this script.
#######################################

DIR_RULER=`dirname $0`

if test "$RULERTYPE" = "Vert"
then
   RULERFILE="${DIR_RULER}/.every10pixelsVert_46x432x8.gif"
else
   RULERFILE="${DIR_RULER}/.every10pixelsHoriz_432x46x8.gif"
fi

#######################################
## Display the 'ruler' file using
## ImageMagick 'display'.
#######################################

/usr/bin/display -immutable "$RULERFILE"
