#!/bin/sh
##
## Nautilus
## SCRIPT: 03_anyfile_show_every10pixelsRULER_display.sh
##
## PURPOSE: Starts up a window showing a 'ruler' GIF file 
##          with lines every 10 pixels.
##
##          This utility is typically used by moving the rule-file
##          window next to an image (could be a video image), to
##          determine how many pixels to crop from the image.
##
## METHOD:  Uses 'zenity --radiolist' to offer a Vertical
##          or a Horizontal ruler.
##
##          Uses ImageMagick 'display' to show the
##          user-specified GIF 'ruler file'.
##
## HOW TO USE: In Nautilus, navigate to ANY directory, and
##             right-click on ANY file. Then select this Nautilus
##             script to run (name above).
##
## Created: 2011feb02
## Changed: 2012feb29 Changed the script name in the comment above.

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
## The ruler files are 'currently' in the
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
## ImageMagick 'display' --- without
## a bunch of menus/options showing.
#######################################

/usr/bin/display -immutable "$RULERFILE"
